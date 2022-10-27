#!/usr/bin/env bash

# pullgists.sh
#
# Syncs gists form github.com to your local computer.
#
# Authentication is by oath. If you don't have a token to use for authentication, then it will alert
# you the first time you run it, as well as give you the command to use to get it.
#
# Once your token is in place, you can run it with your username as an argument to sync gists to $GISTDIR,
# which by default is $HOME/gists. The directory is named <sanitized-description>-<gistid>. The gistid is
# required in the directory name in order to match up the gist to the right directory. If the description
# changes, the directory will be renamed.
#
# If there are any changes in your gist repo, they will be committed and pushed before a git pull is issued.
#
# The JSON returned for each gist will be stored in each directory as .gistinfo.json. This makes it easy
# to find the URL or other info on the gist.
#
# Each directory will also have a .gitignore file added if not already there. The files .gistinfo.json and
# .gitignore will be added to .gitignore and committed
#

set -u
set -o pipefail

GISTDIR=${GISTDIR:-$HOME/gists}
TOKEN_FILE="$HOME/.pullgists.token"
BASEURL="https://api.github.com"
GISTS_PER_PAGE=8
TOKEN=""
GITUSERNAME=""

if [[ ! -f "$TOKEN_FILE" ]]; then
    cat <<EOF
An oauth token is required for pulling gists. To get an oauth token, run the
following command:

    curl \\
        --show-error \\
        --silent \\
        -u "GITUSERNAME" \\
        -d '{"scopes":["gist"],"note":"pullgists.sh"}' \\
        -Hcontent-type:application/json \\
        -Haccept:application/vnd.github.v3+json \\
        -XPOST https://api.github.com/authorizations | jq -r .token

where GITUSERNAME is your Github username. You will be prompted for for your
Github password. The token that is returned and your username should be stored
in $TOKEN_FILE as:

    {
        "githubusername": "GITUSERNAME",
        "token": "TOKEN"
    }

Once this is complete, you may re-run this script to pull your gists.
EOF
    exit 1
fi

function get_token() {
    cat "$TOKEN_FILE" | jq -r .token
}

function get_username() {
    cat "$TOKEN_FILE" | jq -r .gitusername
}

function list_gists() {
    local username=$1
    local page=${2:-1}
    github_req get "/users/$username/gists?per_page=$GISTS_PER_PAGE&page=$page"
}

function github_req() {
    local method=$(echo $1 | tr '[a-z]' '[A-Z]')
    local url=$2
    if [[ "$TOKEN" == "" ]]; then
        TOKEN=$(get_token)
    fi
    if [[ "$TOKEN" == "" ]] || [[ "$TOKEN" == "null" ]]; then
        echo "Unable to get token: $TOKEN" >&2
        return 1
    fi
    curl \
        --silent --show-error \
        -H"Authorization: token $TOKEN" \
        -Hcontent-type:application/json \
        -Haccept:application/vnd.github.v3+json \
        -X$method \
        "$BASEURL$url"
    return $?
}

function is_dirty() {
    local directory=$1
    (cd "$directory" && [[ -z $(git status -s) ]] || echo "dirty")
}

function sanitize() {
    local s=$1
    echo "$s" |
        sed -e "s/['\"]//g" |
        sed -E 's/#(\w+)/(\1)/g' |
        sed 's/*/ /g' |
        sed 's/$/ /g' |
        sed 's/~/ /g' |
        sed 's/:/ /g' |
        sed 's/\s*$//g'
}

function find_existing_repo() {
    local id=$1
    find "$GISTDIR" -name "*-$id" -type d -depth 1
}

function update_repo() {
    local jsongist=$1
    id=$(echo "$jsongist" | jq -r .id)
    desc="$(echo "$jsongist" | jq -r .description)"
    existing_repo_dir=$(find_existing_repo "$id")
    repodir="$GISTDIR/$(sanitize "$desc")-$id"
    echo "--------------------------------------------------------------------------------"
    echo "$id: $desc"
    if [[ "$existing_repo_dir" != "" ]] && [[ "$existing_repo_dir" != "$repodir" ]]; then
        echo "   - title changed to '$repodir'"
        mv "$existing_repo_dir" "$repodir"
    fi
    if [[ ! -d "$repodir" ]]; then
        clone_url=$(echo "$jsongist" | jq -r .git_pull_url)
        echo "   - cloning $clone_url"
        git clone $clone_url "$repodir"
    elif [[ $(is_dirty "$repodir") ]]; then
        echo "   - committing changes and updating repo"
        (cd "$repodir" && git commit -am 'adding changes' && git push && git pull | grep -v 'Already up-to-date')
    else
        echo "   - updating repo"
        (cd "$repodir" && git pull | grep -v 'Already up-to-date')
    fi

    gitignore="$repodir/.gitignore"

    if [[ ! -f "$gitignore" ]]; then
        touch "$gitignore"
        (cd "$repodir" && git add .gitignore)
    fi

    grep -q ".gitignore" "$gitignore"
    if [[ $? == 1 ]]; then
        echo ".gitignore" >>"$gitignore"
    fi

    grep -q ".gistinfo.json" "$gitignore"
    if [[ $? == 1 ]]; then
        echo ".gistinfo.json" >>"$gitignore"
    fi
    if [[ $(is_dirty "$repodir") ]]; then
        echo "   - commiting additional changes"
        (cd "$repodir" && git commit -am "updating .gitignore" && git push)
    fi

    echo "   - saving .gitinfo.json"
    echo "$jsongist" | jq . >"$repodir/.gistinfo.json"
}

function update_all_gists() {
    if [[ ! -d "$GISTDIR" ]]; then
        echo "Creating gist dir '$GISTDIR'"
        mkdir -p "$GISTDIR"
    fi
    GITUSERNAME=$(get_username)
    count=0
    page=1
    while [[ 1 ]]; do
        json=$(list_gists $GITUSERNAME $page)
        if [[ "$?" != 0 ]]; then
            echo "there was a problem listing gists for user $GITUSERNAME" >&2
            break
        fi
        ngists=$(echo "$json" | jq '. | length')
        if [[ "$ngists" == 0 ]]; then
            break
        fi
        pids=""
        for g in $(echo "$json" | jq -rc '.[] | @base64'); do
            gist=$(echo $g | base64 -d)
            update_repo "$gist" &
            count=$((count + 1))
        done
        wait
        page=$((page + 1))
    done
    wait
    echo ">>> $count gists ($page pages)"
}

update_all_gists
