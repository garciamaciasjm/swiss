# Global variables

variable "location" {
  description = "Location of the resource group."
  type        = string
  default     = "East US"
}

variable "v_net" {
  type    = list(any)
  default = ["10.0.0.0/16"]
}


# Firewall:

variable "firewall_subnet_network" {
  type    = list(any)
  default = ["10.0.1.0/24"]
}


# Bastion:

variable "bastion_subnet_network" {
  type    = list(any)
  default = ["10.0.2.0/24"]
}


# Virtual Machines:

variable "vm_subnet_network" {
  type    = list(any)
  default = ["10.0.3.0/24"]
}

variable "prefix" {
  description = "prefix for virtual machine"
  default     = "ubuntu"
  type        = string
}

variable "vm_count" {
  description = "Number of Virtual Machines"
  default     = 1
  type        = string
}

variable "vm_os_version" {
  description = "version of virtual machine"
  default     = "latest"
  type        = string
}

variable "vm_size" {
  description = "size of virtual machine"
  default     = "Standard_B1s"
  type        = string
}

variable "admin_username" {
  description = "Admin username for virtual machine"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for virtual machine"
  type        = string
  sensitive   = true
}
