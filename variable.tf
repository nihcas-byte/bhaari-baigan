variable "rg-list" {
    type = map(object({
        name     = string
        location = string
    }))
}

# Variable to define multiple VNets using a map of objects.
# Each key in the map represents a unique VNet configuration.
# The object contains all the properties needed to create the VNet
# along with its subnets, linked to a specific resource group.
variable "vnet-list" {
    type = map(object({
        # Name of the Virtual Network
        vnet_name = string

        # Address space (CIDR block) for the VNet
        address_space = list(string)

        # Name of the resource group where the VNet will be created
        resource_group_name = string

        # Azure region for the VNet
        location = string

        # List of subnets to create within the VNet.
        # Each subnet has a name and an address prefix (CIDR).
        subnets = list(object({
            name           = string
            address_prefix = string
        }))
    }))
}
