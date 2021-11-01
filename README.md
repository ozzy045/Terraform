# Terraform
 **This repo includes Terraform configurations for provisioning enviroment to azure cloud**
 
 ### The enviroment has the following resources:
 1. Resource Group will be created, given the name you wish with a variable.
 2. A Vnet Resource.
 3. Public and private subnets.
 4. Load balancers and its dependencies.
 5. Network Security Groups (NSG).
 6. A linux virtual machine module, which can be used to create as many as VMs you like.
 7. Postgres service given by azure cloud.
 8. Azure BLOB Storage to keep the state.

## How to provision it by yourself
* Make sure you have terraform installed on your machine. use this [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
* Clone this repo to your own machine.
* Edit the variables and the other fields as you wish.
* Run "Terraform Init"
* Run "Terraform Plan" - take a look what will be provisioned.
* Run Terraform apply.
