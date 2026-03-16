# Cloud-Computing hands-on on Azure -- managed services

## Hands-on 5 -- managed MySQL

The objective of this hands-on session is to discover one managed service: "MySQL flexible server".

Here are the main steps to perform:
- provision the service so that it is accessible from you private IP address and from a `private endpoint`
- set the MySQL parameter `require_secure_transport` to `OFF`
- connect to the MySQL server from your laptop and confirm that you can use it
- connect to the MySQL server from a VM hosted in the `virtual network` and confirm you can use it

> Note that the IP address bound to the DNS name are not the same whether you resolve the name from you laptop or from the VM  
> **Why?**
