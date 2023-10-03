#!/usr/bin/env bash

# First run "kubectl proxy"
# then run "kubectl get namespaces | grep Terminating | awk '{print $1}'"
# review the list and run this script

function remove_finalizer {
  local ns="$1"
  kubectl get ns "$ns" -o json | jq 'del(.spec.finalizers[0])' >$ns.json
  curl -k -H "Content-Type: application/json" -X PUT --data-binary @$ns.json http://127.0.0.1:8001/api/v1/namespaces/$ns/finalize
  rm "$ns.json"
}

for ns in $(cat ./terminating.txt); do
  echo "=== $ns === "
  remove_finalizer "$ns"
done
