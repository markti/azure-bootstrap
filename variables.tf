variable "location" {
  type = string
}
variable "network" {
  type = object({
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = string
  })
}