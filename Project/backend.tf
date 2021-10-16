terraform {
    backend "azurerm" {
        resource_group_name  = "terraform-project"
        storage_account_name = "tfstatezdk5m"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}
