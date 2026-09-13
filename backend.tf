terraform {
  backend "azurerm" {
    resource_group_name  = "rg-data-prod"
    storage_account_name = "aviralprod002"
    container_name       = "tfstate"
    key                  = "local.terraform.tfstate"
  }
}