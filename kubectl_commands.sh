# Get logs for all pods with a given label
kubectl logs -f -l app=my-app-label

# Get pod labels
kubectl get pods --show-labels

# ^^^ can be messy, so if your app label is the name of the deployment,
# just list the deployments
kubectl get deployments

# and then get logs for that app=deployment
kubectl logs -f -l app=my-deployment

########
# see also https://kubernetes.io/docs/reference/kubectl/cheatsheet/
