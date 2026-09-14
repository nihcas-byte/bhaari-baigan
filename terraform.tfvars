rg-list = {
  rg1 = {
    name     = "rg-data-prod"
    location = "centralindia"
  }
  rg2 = {
    name     = "rg-data-dev"
    location = "centralindia"
  }
  rg3 = {
    name     = "rg-data-test"
    location = "westindia"
  }
  rg4 = {
    name     = "rg-data-qa"
    location = "westindia"
  }
}

# ---------------------------------------------------------------
# VNet configuration map.
# Each key (e.g., "prod", "dev") represents a VNet to create.
# The object contains the VNet name, CIDR, resource group,
# location, and a list of subnets with their address prefixes.
# ---------------------------------------------------------------
vnet-list = {
  # Production VNet — 10.0.0.0/16 address space
  # Contains webapp and backend subnets
  prod = {
    vnet_name           = "vnet-prod"
    address_space       = ["10.0.0.0/16"]
    resource_group_name = "rg-data-prod"
    location            = "centralindia"
    subnets = [
      {
        # Subnet for web application tier
        name           = "webapp"
        address_prefix = "10.0.1.0/24"
      },
      {
        # Subnet for backend services
        name           = "backend"
        address_prefix = "10.0.2.0/24"
      }
    ]
  }

  # Development VNet — 172.16.0.0/24 address space
  # Contains webapp and backend subnets
  dev = {
    vnet_name           = "vnet-dev"
    address_space       = ["172.16.0.0/24"]
    resource_group_name = "rg-data-dev"
    location            = "centralindia"
    subnets = [
      {
        # Subnet for web application tier
        name           = "webapp"
        address_prefix = "172.16.0.0/25"
      },
      {
        # Subnet for backend services
        name           = "backend"
        address_prefix = "172.16.0.128/25"
      }
    ]
  }
}
