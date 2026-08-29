terraform {

  backend "azurerm" {
    resource_group_name  = "gauravstgforstate"
    storage_account_name = "gauravstgforstate"
    container_name       = "gauravstgforstate"
    key                  = "terraform.tfstate"



  }

}