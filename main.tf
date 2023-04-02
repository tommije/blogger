provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "blog" {
  name     = "blogResourceGroup"
  location = "West Europe"
}

resource "azurerm_storage_account" "blog" {
  name                     = "blogstorage"
  resource_group_name      = azurerm_resource_group.blog.name
  location                 = azurerm_resource_group.blog.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
}

output "static_website_url" {
  value = azurerm_storage_account.blog.primary_web_endpoint
}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "statestorage"
    container_name       = "tfstate"
    key                  = "blog.tfstate"
  }
}
