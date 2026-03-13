#!/bin/bash

LOCATION=${1:-"northeurope"}
RG_NAME=${2:-"hexagone-cloud"}
VM_NAME=${3:-"frontend-vm-1"}
SIZE=${4:-"Standard_B1s"}
VNET_NAME=${5:-"hexagone-cloud-vnet"}
SUBNET_NAME=${6:-"frontend"}
CLOUD_INIT_FILE=${7:-"./frontend-vm-cloud-init"}

az vm create \
  --location $LOCATION \
  --resource-group $RG_NAME \
  --name $VM_NAME \
  --size $SIZE \
  --image canonical:ubuntu-24_04-lts:server:latest \
  --admin-username mdimonte \
  --ssh-key-values "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDloWmbHQuWX6d9MC3Vq/P5EiK206vn3Y4rKAjIhl/Fc mdimonte@cabyla11" \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --storage-sku os=Standard_LRS \
  --security-type TrustedLaunch \
  --enable-secure-boot true \
  --enable-vtpm true \
  --os-disk-delete-option Delete \
  --nic-delete-option Delete \
  --public-ip-address "" \
  --nsg "" \
  --custom-data @$CLOUD_INIT_FILE
