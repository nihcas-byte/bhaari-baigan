variable "rg-list" {
    type = map(object({
        name     = string
        location = string
    }))
}
