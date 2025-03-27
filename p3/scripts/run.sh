#!/bin/bash

if k3d cluster list nosterme &> /dev/null ; then
	echo "K3d cluster nosterme already exists"
else
	echo "Creating k3d cluster nosterme"
	k3d cluster create --config confs/k3d.yaml
fi

if kubectl get ns dev &> /dev/null ; then
	echo "Namespace dev already exists"
else
	echo "Creating namespace dev"
	kubectl create namespace dev
fi

if kubectl get ns argocd &> /dev/null ; then
	echo "Namespace argocd already exists"
else
	echo "Creating namespace argocd"
	kubectl create namespace argocd
fi

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for condition=Ready pods --all -n argocd --timeout 120s
kubectl apply -f confs/user.yaml -f confs/project.yaml -f confs/application.yaml -n argocd

kubectl port-forward service/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)
argocd login --username admin --password $PASSWORD localhost:8080 --insecure
argocd account update-password --account nosterme --new-password nosterme --current-password $PASSWORD

echo "Go to https://localhost:8080 to access argoCD"
echo ""
echo "ArgoCD user credentials:"
echo "username: nosterme"
echo "password: nosterme"
