variable "vpc_module_enabled" {
  description = "Whether this resource has to be created or not"
  default     = false
}

variable "name" {
  description = "generic name for the resources"
  type        = string
  default     = "test-vpc"
}

variable "vpc_cidr" {
  description = "cidr range for the vpc network"
  default = "10.1.0.0/16"
}

variable "vpc_id" {
  description = "VPC id after creation of VPC"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "pub_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "priv_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_suffix" {
  default = "pub-sub"
}

variable "priv_subnet_suffix" {
  default = "priv-sub"
}

variable "bck_subnet_suffix" {
  default = "bck-sub"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
