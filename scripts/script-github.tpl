#!/bin/bash

# wait 60 seconds until instance fully initialized - needed here so that GitHub registration command is successful
sleep 60

# update package repos
sudo apt update

# Install GitHub Actions runner
curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz
sudo mkdir -p /opt/github-actions
sudo mv actions-runner-linux-x64-2.317.0 /opt/github-actions
cd /opt/github-actions

# Install docker on Ubuntu 22.04
sudo apt install docker.io -y

# Add github-actions & ubuntu users to docker group
sudo usermod -aG docker github-actions
sudo usermod -aG docker ubuntu

# Start docker to apply the above change
systemctl restart docker

# Install AWS CLI 
sudo apt install awscli -y

## register runner
sudo ./config.sh --url "https://github.com/${github_repo}" --token "${runner_registration_token}"
sudo ./svc.sh install
sudo ./svc.sh start
