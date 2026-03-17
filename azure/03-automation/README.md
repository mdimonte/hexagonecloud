# Cloud-Computing hands-on on Azure -- automation

The objective is to start automating provisioning activites on Azure using tools that are designed for that purpose (I mean automation).

## Create a Service Principal

Using the [Azure portal](https://portal.azure.com) execute these 2 main steps:
1. create a `Service Principal`:
    - Search for `App registrations`
    - select "New registration" and provide required information
2. create a secret for this `Service Principal`:
    - select the new `Service Principal`
    - from the menu on the left select "> Manage > Certificates & secrets"
    - on the main panel, select "Client secrets" then click on "New client secret"
    - !! register the `Secret` generated: it will not be disclosed again

## Ansible installation

The objective here is to describe the technical steps to install `ansible` in a pyhton virtual environment

### Technical steps

Run the following commands from a terminal

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install ansible
deactivate
source .venv/bin/activate
ansible-galaxy collection install azure.azcollection
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt
ansible-galaxy collection list
deactivate
source .venv/bin/activate
```

## Create a first ansible playbook

As a reminder here are:
- the list of [Ansible collections](https://docs.ansible.com/projects/ansible/latest/collections/index.html)
- the list of [Ansible modules](https://docs.ansible.com/projects/ansible/latest/collections/index_module.html)
- the list of the [modules of the Ansible collection for Azure](https://docs.ansible.com/projects/ansible/latest/collections/azure/azcollection/index.html#plugins-in-azure-azcollection)

**This first Ansible playbook should:**
- create a new `Azure resource group` using the module [`azure.azcollection.azure_rm_resourcegroup`](https://docs.ansible.com/projects/ansible/latest/collections/azure/azcollection/azure_rm_resourcegroup_module.html#ansible-collections-azure-azcollection-azure-rm-resourcegroup-module)

:warning:  
all modules of the Ansible collection for Azure require these 4 environment variables to be set properly to work fine:  
- AZURE_TENANT
- AZURE_SUBSCRIPTION_ID
- AZURE_CLIENT_ID
- AZURE_SECRET

Setting these variables can be done by adding such a bloc in a 'play' before the section `tasks`:  
```yaml
  environment:
    AZURE_TENANT: "{{ azure_tenant }}"
    AZURE_SUBSCRIPTION_ID: "{{ azure_subscription_id }}"
    AZURE_CLIENT_ID: "{{ azure_client_id }}"
    AZURE_SECRET: "{{ azure_secret }}"
```

Then, invoking the playbook should be done like this:  
```bash
ansible-playbook my-playbook.yaml \
--extra-vars azure_tenant="xxxx" \
--extra-vars azure_subscription_id="xxxx" \
--extra-vars azure_client_id="xxxx" \
--extra-vars azure_secret="xxxx"
```

## Update the ansible playbook

Update teh playbook you have created above so that:
- it creates a `Virtual Network`
- it creates 2 `subnets` in the `Virtual Network`
