#!/bin/bash

destination_dir=$1

cd "$destination_dir"
region='UK South'
region_short_name='uks'

SUBSCRIPTION_NAME=$(az account show --query name -o tsv | tr -d "\n\r" )
BACKEND_RESOURCEGROUP_NAME=$(echo "rg-${region_short_name}-${SUBSCRIPTION_NAME}-core-01")
BACKEND_STORAGE_ACCOUNT_NAME=$(az storage account list -g $BACKEND_RESOURCEGROUP_NAME --query '[].name' -o tsv | grep tfstate | tr -d "\n\r")  

echo "Using infromation:"
echo "  Subscription Name: $SUBSCRIPTION_NAME";
echo "  Resource Group Name: $BACKEND_RESOURCEGROUP_NAME";
echo "  Region: $region";
echo "  Storage Account: $BACKEND_STORAGE_ACCOUNT_NAME";

export ARM_ACCESS_KEY=$(az storage account keys list -g $BACKEND_RESOURCEGROUP_NAME -n $BACKEND_STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

terraform init -reconfigure -upgrade

terraform apply -input=false -parallelism=50 tfplan