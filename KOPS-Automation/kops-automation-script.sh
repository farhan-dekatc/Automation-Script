#!/bin/bash

#Variables
AWS_ACCESS_KEY_ID=AKIAWSE7AI6TDYDLECFO
AWS_SECRET_ACCESS_KEY=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
AWS_REGION=us-east-1
AWS_OUTPUT_FORMAT=json
HOSTED_ZONE_NAME=realits.cnssure.ml
STATE=s3://cns-kops-state
ZONE1=us-east-1a
ZONE2=us-east-1b
NO_OF_NODES=2
NODE_SIZE=t3.small
MASTER_SIZE=t3.medium
NODE_VOLUME_SIZE=8
MASTER_VOLUME_SIZE=8

#key-generation
ssh-keygen

#aws installation and configuration
sudo apt update && sudo apt install awscli -y
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_REGION
aws configure set output $AWS_OUTPUT_FORMAT

#kubectl installation and setup
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/

#kops installation and setup
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

#cluster creation
kops create cluster --name=$HOSTED_ZONE_NAME --state=$STATE --zones=$ZONE1,$ZONE2 --node-count=$NO_OF_NODES --node-size=$NODE_SIZE --master-size=$MASTER_SIZE --dns-zone=$HOSTED_ZONE_NAME --node-volume-size=$NODE_VOLUME_SIZE --master-volume-size=$MASTER_VOLUME_SIZE
kops update cluster --name $HOSTED_ZONE_NAME --state=$STATE --yes --admin
