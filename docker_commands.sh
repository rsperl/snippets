#!/bin/bash

# sort by created
jq -s -c 'sort_by(.CreatedAt)[]' <(docker images --format '{{json .}}') | jq .

# returns json array of image repositories
function list_image_repos() {
    jq -c --slurp --raw-input 'split("\n")[:-1]' <(docker images --format '{{.Repository}}' | sort | uniq)
}

# returns json array of image tags for a given image
function list_image_tags() {
    local repo="$1"
    if [[ -z "$repo" ]]; then
        echo "Usage: ${FUNCNAME[0]} <repository>"
        return 1
    fi
    jq -c -s 'sort_by(.CreatedAt)[]' <(docker images --filter reference="$repo" --format '{{json .}}')
}

# removes older image tags for a given image, but keeping $keep
function remove_old_images() {
    local repo="$1"
    local keep="$2"
    tags=$(list_image_tags $repo)
    ntags=$(echo "$tags" | wc -l)
    ntagsdelete=$(($ntags - $keep))
    tags_to_delete=$(echo "$tags" | head -$ntagsdelete)
    echo "Repository: $repo"
    echo "Tags:       $ntags"
    echo "Keep:       $keep"
    echo "Delete:     $ntagsdelete"
    if [[ "$ntagsdelete" < 1 ]]; then
        echo "No images to delete"
        return 0
    fi
    echo "$tags_to_delete" | while read -r line; do
        createdat=$(echo "$line" | jq -r '.CreatedAt')
        tag=$(echo "$line" | jq -r '.Tag')
        id=$(echo "$line" | jq -r '.ID')
        echo "Deleting $repo:$tag ($id) created at $createdat"
        docker rmi "$id"
    done
}

