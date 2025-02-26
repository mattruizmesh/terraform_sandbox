terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.17.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name   = "rg-statefiles-dv"
    storage_account_name  = "mattstatefiles"
    container_name        = "tfstate"
    key                   = "sandbox.tfstate"
    
  }
}

provider "azurerm" {
  features {
    # Azurerm provider specific configurations
  }
  # Should probably be provided by a variable
  subscription_id = "96de2334-ebc2-465f-aa5c-29eb35ad9510"
}

locals {
  # Local variables
}