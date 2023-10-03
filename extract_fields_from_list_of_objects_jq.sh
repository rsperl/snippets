#!/usr/bin/env bash

FILENAME="$1"

# cat "$FILENAME" | jq '
# [
#     .results[0].vulnerabilities[]
#     | select(.packageName == "go")
#     | select(.severity == "critical")
#     |  .packagePath
# ]
#     | sort
#     | unique'

cat "$FILENAME" |
  jq -r '
    (
        .results[0].vulnerabilities[0] 
        | { "id": .id, "severity": .severity, "packageName": .packageName, "packagePath": .packagePath }
        | 
            (
                [keys[] | .] 
                | (., map(length*"-"))
            )
    ), 
    (
        .results[0].vulnerabilities[] 
        | { "id": .id, "severity": .severity, "packageName": .packageName, "packagePath": .packagePath }
        | 
            (
                [keys[] as $k | .[$k]]
            )
    ) 
    | @tsv
' | column -t -s $'\t'
