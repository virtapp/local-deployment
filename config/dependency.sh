#!/bin/bash
sudo apt-get update -y && sudo apt-get install docker.io -y
sudo service docker restart
sleep 5
   echo    "----- ..................................................... -----"
   echo      "----- ...............   TERRAFORM .................... -----"
   echo    "----- ..................................................... -----"
sudo wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip
sudo apt install zip -y
sudo unzip terraform_0.14.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sleep 5
   echo    "----- ..................................................... -----"
   echo        "----- ...............   HELM   .................... -----"
   echo    "----- ..................................................... -----"
sudo curl -# -LO https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz
sudo tar -xzvf helm-v3.5.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm -rf helm-v3.5.3-linux-amd64.tar.gz && sudo rm -rf linux-amd64
sleep 5
   echo    "----- ..................................................... -----"
   echo       "----- ...............   KUBECTL  .................... -----"
   echo    "----- ..................................................... -----"
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
