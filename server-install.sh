#!/bin/bash

#echo 'set host name resolution'
#cat >> /etc/hosts <<EOF
#192.168.56.10 server
#192.168.56.11 agent1
#192.168.56.12 agent2
#EOF
#cat /etc/hosts
echo 'install helm'
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm version
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

#load balance
helm repo add metallb https://metallb.github.io/metallb
helm search repo metallb
helm upgrade --install metallb metallb/metallb --create-namespace --namespace metallb-system --wait
cat << 'EOF' | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.56.200-192.168.56.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
EOF


kubectl get svc -n kube-system
kubectl get pods -n metallb-system

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=LoadBalancer --name=nginx --port=80 --protocol=TCP
kubectl get svc
#kubectl delete all -l app=nginx
