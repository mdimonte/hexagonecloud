# Cloud-Computing hands-on on Azure -- automation

The objective is to start automating provisioning activites on Azure using tools that are designed for that purpose (I mean automation).

## Ansible installation instructions

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
```
