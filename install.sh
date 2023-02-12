#!/usr/bin/env sh

set -e
cat <<EOF

Typical installation of the Local Environment 
    1. ### Install Packages
    2. ### Kubernetes Cluster
    3. ### Deploy Charts 
EOF
sleep 5
export path_charts="charts"
export path_folder="argocd"
             echo      "----- ............................. -----"
             echo         "---  Install Dependencies ---"
             echo      "----- ............................. -----"
source config/dependency.sh
sleep 5 && sudo docker ps -a || true

             echo      "----- ............................. -----"
             echo         "---  LOAD-TERRAFORM-FILES  ---"
             echo      "----- ............................. -----"
sleep 5         
terraform init || exit 1
terraform validate || exit 1 && terraform plan
terraform apply -auto-approve
sleep 10 && kubectl get pods -A && sleep 5

             echo      "----- ............................. -----"
             echo          "---  HELM UPDATE REPO  ---"
             echo      "----- ............................. -----"
             
helm repo add bitnami https://charts.bitnami.com/bitnami || true
helm repo add hashicorp https://helm.releases.hashicorp.com|| true
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts || true
helm repo add kedacore https://kedacore.github.io/charts || true
helm repo update && sleep 5
helm fetch rancher-latest/rancher --version=v2.7.0 || true
kubectl create namespace cattle-system || true
helm install rancher rancher-latest/rancher --version=v2.7.0 \
  --namespace cattle-system \
  --set hostname=console.appflex.io \
  --set ingress.tls.source=appflex \
  --set replicas=1 \
  --set bootstrapPassword="admin"
kubectl create namespace keda || true
helm install keda kedacore/keda --namespace keda && sleep 5
echo    Waiting for all pods in running mode:
until kubectl wait --for=condition=Ready pods --all -n keda; do
sleep 2
done  2>/dev/null

             echo      "----- ............................. -----"
             echo         "---  LOAD-ARGO-APPLICATIONS  ---"
             echo      "----- ............................. -----"      
             
sleep 5 &&           
kubectl apply -f ./${path_folder}/app-apache.yaml
kubectl apply -f ./${path_folder}/app-httpd.yaml
sleep 5 && kubectl create namespace appflex || true
               printf "\nWaiting for application will be ready... \n"
printf "\nYou should see 'dashboard' as a reponse below (if you do the ingress is working):\n"

             echo      "----- ............................. -----"
             echo         "---  CREATE INGRESS RULES  ---"
             echo      "----- ............................. -----"
             
kubectl apply -f ./${path_folder}/ingress-keyclock.yaml || true
kubectl apply -f ./${path_folder}/ingress-argocd.yaml   || true
sleep 5 && 
kubectl get nodes -o wide && sleep 5
terraform providers

             echo      "----- ............................. -----"
             echo           "---  CLUSTER IS READY  ---"
             echo      "----- ............................. -----"
