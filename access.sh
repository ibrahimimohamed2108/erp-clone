#!/bin/bash
# This script is used to get the argocd, prometheus & grafana urls & credentials

aws configure
aws eks update-kubeconfig --region "us-east-1" --name "emierp-cluster"

# ArgoCD Access
argo_url=$(kubectl get svc -n argocd | grep argocd-server | awk '{print$4}' | head -n 1)
argo_initial_password=$(argocd admin initial-password -n argocd)

# ArgoCD Credentials
argo_user="admin"
argo_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

# Prometheus URL
prometheus_url=$(kubectl get svc -n prometheus | grep stable-kube-prometheus-sta-prometheus | awk '{print $4}')

# Grafana URL and credentials with dynamic secret discovery
grafana_url=$(kubectl get svc -n prometheus | grep stable-grafana | awk '{print $4}')
grafana_user="admin"

# Find Grafana secret dynamically
echo "Looking for Grafana secret..."
grafana_secret=$(kubectl get secrets -n prometheus 2>/dev/null | grep -i grafana | awk '{print $1}' | head -n 1)

if [ ! -z "$grafana_secret" ]; then
    echo "Found Grafana secret: $grafana_secret"
    # Try different possible password field names
    grafana_password=$(kubectl get secret $grafana_secret -n prometheus -o jsonpath="{.data.admin-password}" 2>/dev/null | base64 --decode 2>/dev/null)
    
    if [ -z "$grafana_password" ]; then
        grafana_password=$(kubectl get secret $grafana_secret -n prometheus -o jsonpath="{.data.password}" 2>/dev/null | base64 --decode 2>/dev/null)
    fi
    
    if [ -z "$grafana_password" ]; then
        grafana_password=$(kubectl get secret $grafana_secret -n prometheus -o jsonpath="{.data.admin}" 2>/dev/null | base64 --decode 2>/dev/null)
    fi
    
    if [ -z "$grafana_password" ]; then
        echo "Available keys in secret $grafana_secret:"
        kubectl get secret $grafana_secret -n prometheus -o jsonpath="{.data}" | jq -r 'keys[]' 2>/dev/null || echo "Could not list secret keys"
        grafana_password="Password field not found in secret"
    fi
else
    echo "No Grafana secret found. Available secrets in prometheus namespace:"
    kubectl get secrets -n prometheus 2>/dev/null | grep -v "TYPE" || echo "Could not list secrets"
    grafana_password="Grafana secret not found"
fi

# Print or use these variables
echo "========================"
echo "ArgoCD URL: $argo_url"
echo "ArgoCD User: $argo_user"
echo "ArgoCD Initial Password: $argo_initial_password" | head -n 1
echo "ArgoCD Admin Password: $argo_password"
echo
echo "Prometheus URL: $prometheus_url:9090"
echo
echo "Grafana URL: $grafana_url"
echo "Grafana User: $grafana_user"
echo "Grafana Password: $grafana_password"
echo "========================"

# Additional troubleshooting info
echo
echo "Troubleshooting Information:"
echo "Available services in prometheus namespace:"
kubectl get svc -n prometheus 2>/dev/null || echo "Could not list services in prometheus namespace"

echo
echo "Available secrets in prometheus namespace:"
kubectl get secrets -n prometheus 2>/dev/null || echo "Could not list secrets in prometheus namespace"

# Run below commands to use this script:
# chmod +x access.sh
# ./access.sh