#!/bin/bash


az group delete --name rg-uks-dev-digital-hybrid-apps --yes --no-wait
az group delete --name rg-uks-digital-hybrid-shared --yes --no-wait
az group delete --name rg-uks-digital-hybrid-network --yes --no-wait
