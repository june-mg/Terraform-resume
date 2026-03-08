# Create a Resource Group
resource "azurerm_resource_group" "resume_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create the Storage Account for the Website
resource "azurerm_storage_account" "resume_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resume_rg.name
  location                 = azurerm_resource_group.resume_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  }

  # This block enables web hosting
resource "azurerm_storage_account_static_website" "resume_website" {
  storage_account_id = azurerm_storage_account.resume_storage.id
  index_document     = "index.html"
}

resource "azurerm_storage_blob" "resume_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.resume_storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "./website/index.html"
  content_md5            = filemd5("./website/index.html")
}

output "website_url" {
  value = azurerm_storage_account.resume_storage.primary_web_endpoint
}