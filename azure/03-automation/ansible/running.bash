#!/bin/bash

ansible-playbook ./ansible/exemple_azure.playbook.yaml \
    --extra-vars "azure_tenant=MY_TENANT_ID" \
    --extra-vars "azure_subscription_id=MY_SUBSCRIPTION_ID" \
    --extra-vars "azure_client_id=MY_CLIENT_ID" \
    --extra-vars "azure_secret=MY_SECRET"


