#!/usr/bin/env sh

set -e
cat <<EOF

Typical installation of the Local Environment 
    1. ### Install Packages
    2. ### Create Kubernetes Cluster
    3. ### Deploy Charts 
EOF
sleep 5
export path_charts="charts"
export path_folder="argocd"

             echo      "----- ............................. -----"
             echo           "--- INSTALL DEPENDENCIES ---"
             echo      "----- ............................. -----"
             
source config/dependency.sh
sleep 5 && sudo docker ps -a || true
             echo      "----- ............................. -----"
             echo           "---  LOAD-TERRAFORM-FILES  ---"
             echo      "----- ............................. -----"
sleep 5         
terraform init || exit 1
terraform validate || exit 1 
terraform plan && terraform apply -auto-approve
sleep 10 && kubectl get pods -A && sleep 5

             echo      "----- ............................. -----"
             echo           "---  HELM UPDATE REPO  ---"
             echo      "----- ............................. -----"
             
helm repo add bitnami https://charts.bitnami.com/bitnami || true
helm repo add hashicorp https://helm.releases.hashicorp.com|| true
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts || true
helm repo add kedacore https://kedacore.github.io/charts || true
helm repo update && sleep 5
helm fetch rancher-latest/rancher --version=v2.7.0 || true
kubectl create namespace infra || true
kubectl create namespace cattle-system || true
helm install rancher rancher-latest/rancher --version=v2.7.0 \
  --namespace cattle-system \
  --set hostname=app-console.virtapp.io \
  --set ingress.tls.source=virtapp \
  --set replicas=1 \
  --set bootstrapPassword="YWRtaW4="
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
kubectl apply -f ./${path_folder}/app-infra.yaml
kubectl apply -f ./${path_folder}/app-httpd.yaml
kubectl apply -f ./${path_folder}/app-local.yaml
               printf "\nWaiting for application will be ready... \n"
printf "\nYou should see 'dashboard' as a reponse below (if you do the ingress is working):\n"

             echo      "----- ............................. -----"
             echo         "---  CREATE INGRESS RULES  ---"
             echo      "----- ............................. -----"

sleep 5 &&
kubectl apply -f ./${path_folder}/ingress-app.yaml || true
kubectl apply -f ./${path_folder}/ingress-argocd.yaml   || true
kubectl apply -f ./${path_folder}/ingress-jenkins.yaml  || true
sleep 5 && kubectl get nodes -o wide && sleep 5
terraform providers && kubectl get ing -A


             echo      "----- ............................. -----"
             echo           "---  CLUSTER IS READY  ---"
             echo      "----- ............................. -----"


