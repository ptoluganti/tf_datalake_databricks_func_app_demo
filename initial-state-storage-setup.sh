#!/bin/bash

region='UK South'
region_short_name='uks'
subscription_name="$(az account show --query name -o tsv  | tr '[:upper:]' '[:lower:]' | tr -d '\r')"
resource_group_name=$(echo "rg-${region_short_name}-${subscription_name}-core-01")

IFS='-' read -ra sub_array <<< "$subscription_name"
CLIENT_PREFIX=${sub_array[1]}

STORAGE_ACCOUNT_NAME="st${region_short_name}${CLIENT_PREFIX:0:4}gtfstate"
CONTAINER_NAME='tfstate'


echo "Using infromation:"
echo "  Subscription Name: $subscription_name";
echo "  Resource Group Name: $resource_group_name";
echo "  Region: $region";
echo "  Storage Account: $STORAGE_ACCOUNT_NAME";
echo "  Storage Container: $CONTAINER_NAME";

# az account set --subscription $subscription &> /dev/null

# Create resource group
az group create --location "$region" --resource-group "$resource_group_name"  &> /dev/null

# Create storage account
az storage account create --resource-group $resource_group_name --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob &> /dev/null

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $resource_group_name --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv) 

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY &> /dev/null
