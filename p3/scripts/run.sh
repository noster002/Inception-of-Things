#!/bin/bash

k3d cluster create nosterme -p 8888:30888@server:0

kubectl create namespace dev && kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for condition=Ready pod --all -n argocd --timeout 120s
kubectl apply -f confs/project.yaml -f confs/application.yaml -n argocd

kubectl port-forward service/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
echo "Go to https://localhost:8080 to access argoCD"
echo ""
echo "ArgoCD user credentials:"
echo "username: admin"
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)
echo "password: $PASSWORD"

argocd login --username=admin --password=$PASSWORD localhost:8080 --insecure
