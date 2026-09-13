resource "azurerm_resource_group" "rg" {
  for_each = var.rg-list

  name     = each.value.name
  location = each.value.location
}

# ---------------------------------------------------------------
# Virtual Network resource using for_each with a map of objects.
# Each key in var.vnet-list creates a separate VNet.
# The for_each meta-argument iterates over the map, and each
# VNet gets its configuration from the corresponding object.
# ---------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  # Iterate over each entry in the vnet-list map.
  # The map key (e.g., "prod", "dev") becomes the resource instance key.
  for_each = var.vnet-list

  # VNet name from the map object
  name = each.value.vnet_name

  # Address space (CIDR) for the VNet
  address_space = each.value.address_space

  # Resource group and location from the map object
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  # Ensure the resource group is created before the VNet
  depends_on = [azurerm_resource_group.rg]
}

# ---------------------------------------------------------------
# Subnet resource using for_each with a flattened map.
# Since each VNet can have multiple subnets, we use a 'locals'
# block to flatten the nested structure into a single map.
# This creates a unique key per subnet (e.g., "prod-webapp")
# so that each subnet is a distinct resource instance.
# ---------------------------------------------------------------

# Flatten the nested subnets into a single map for for_each.
# This transforms the vnet-list (which has a list of subnets per VNet)
# into a flat map where each key uniquely identifies a subnet.
locals {
  subnets = merge([
    for vnet_key, vnet in var.vnet-list : {
      for subnet in vnet.subnets :
      "${vnet_key}-${subnet.name}" => {
        # Subnet name
        name = subnet.name

        # Subnet address prefix (CIDR)
        address_prefix = subnet.address_prefix

        # Reference back to the parent VNet key for linking
        vnet_key = vnet_key

        # VNet name needed for the subnet resource
        vnet_name = vnet.vnet_name

        # Resource group name for the subnet
        resource_group_name = vnet.resource_group_name
      }
    }
  ]...)
}

resource "azurerm_subnet" "subnet" {
  # Iterate over the flattened subnet map.
  # Each key (e.g., "prod-webapp", "dev-backend") is a unique subnet.
  for_each = local.subnets

  # Subnet name from the flattened map
  name = each.value.name

  # Link the subnet to its parent VNet and resource group
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name

  # Subnet address prefix (CIDR)
  address_prefixes = [each.value.address_prefix]

  # Ensure the parent VNet is created before the subnet
  depends_on = [azurerm_virtual_network.vnet]
}
