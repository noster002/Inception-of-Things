#!/bin/bash

k3d cluster create nosterme -p 8888:30888@server:0

kubectl create namespace dev
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for condition=Ready pod --all -n argocd --timeout 120s

kubectl port-forward service/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)
argocd login --username admin --password $PASSWORD localhost:8080 --insecure
argocd account update-password --current-password $PASSWORD --new-password bookworm

kubectl apply -f confs/deployment.yaml -n argocd
