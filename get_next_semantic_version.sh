#!/bin/bash

env="test"
increment="count"
lastversion=""
debug="0"

function echo_out() {
    local msg="$1"
    if [[ "$debug" == "1" ]]; then
        echo ">> $msg"
    fi
}

function echo_err() {
    local msg="$1"
    echo >&2 "$msg"
}

function usage() {
    echo_err "Usage: $0 [-e <env>] [-i <field-to-increment>]"
    echo_err "  -e <env>           environment tag to use (default=test)"
    echo_err "  -i <field-to-inc>  one of major, minor, patch, or count (default=count)"
    echo_err ""
    echo_err "Tags are in the format vMajor.Minor.Patch-EnvCount"
    echo_err ""
    echo_err "Example: get the next count when the latest release for test is"
    echo_err "is v4.2.1-test3:"
    echo
    echo_err "./$0 -e test -i count"
    echo_err "v4.2.1-test3"
    exit 1
}

while getopts ":de:i:l:?" opt; do
    case ${opt} in
    d) debug=1
        ;;
    e) env="$OPTARG"
        ;;
    i) increment="$OPTARG"
        ;;
    l) lastversion="$OPTARG"
        ;;
    \?)
        usage
        ;;

    esac
done

if [[ ! "$env" =~ ^[a-z]+$ ]]; then
    echo_err "invalid env -- must be letters and numbers only"
    exit 1
fi

set -u
source=""
if [[ "$lastversion" == "" ]]; then
    lastversion=$(git tag --sort=-creatordate -l "v*-$env[0-9]*" | head -1)
    source="git"
else
    source="command line option"
fi

echo_out "env:                $env"
echo_out "field to increment: $increment"

if [[ "$lastversion" == "" ]]; then
    echo "failed to get latest version"
    exit 1
fi

echo_out "last version:       $lastversion (from $source)"

major=$(echo $lastversion | sed -e 's/^v//' | awk -F. '{print $1}')
minor=$(echo $lastversion | sed -e 's/^v//' | awk -F. '{print $2}')
patch=$(echo $lastversion | sed -e 's/^v//' | awk -F. '{print $3}' | awk -F- '{print $1}')
count=$(echo $lastversion | sed -e 's/^v//' | awk -F- '{print $2}' | sed -e "s/$env//")

if [[ "$debug" == "1" ]]; then
    echo_out "Major: $major"
    echo_out "Minor: $minor"
    echo_out "Patch: $patch"
    echo_out "Count: $count"
fi

if [[ "$increment" == "count" ]]; then
    count=$(($count + 1))
elif [[ "$increment" == "patch" ]]; then
    patch=$(($patch + 1))
    count=1
elif [[ "$increment" == "minor" ]]; then
    minor=$(($minor + 1))
    patch=0
    count=1
elif [[ "$increment" == "major" ]]; then
    major=$(($major + 1))
    minor=0
    patch=0
    count=1
else
    echo_err "increment must be one of major, mino, patch, or count"
    exit 1
fi

newversion="v$major.$minor.$patch-$env$count"
echo $newversion
