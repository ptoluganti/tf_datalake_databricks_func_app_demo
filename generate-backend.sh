#!/bin/bash

destination_dir=$1
region='UK South'
region_short_name='uks'

SUBSCRIPTION_NAME=$(az account show --query name -o tsv | tr -d "\n\r" )
BACKEND_RESOURCEGROUP_NAME=$(echo "rg-${region_short_name}-${SUBSCRIPTION_NAME}-core-01")
BACKEND_STORAGE_ACCOUNT_NAME=$(az storage account list -g $BACKEND_RESOURCEGROUP_NAME --query '[].name' -o tsv | grep tfstate | tr -d "\n\r")  
BACKEND_FILE_NAME="${STATE_FILE_NAME}.tfstate"

echo "Using infromation:"
echo "  Subscription Name: $SUBSCRIPTION_NAME";
echo "  Resource Group Name: $BACKEND_RESOURCEGROUP_NAME";
echo "  Region: $region";
echo "  Storage Account: $BACKEND_STORAGE_ACCOUNT_NAME";
echo "  BACKEND_FILE_NAME $BACKEND_FILE_NAME";

backend_file_data=$(cat <<EOF
terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$BACKEND_RESOURCEGROUP_NAME\"
    storage_account_name = \"$BACKEND_STORAGE_ACCOUNT_NAME\"
    container_name       = \"tfstate\"
    key                  = \"$BACKEND_FILE_NAME\"
  }
}
EOF
)
echo "current location: $destination_dir"
eval "echo \"${backend_file_data}\"" > "$destination_dir/backend.tf"
