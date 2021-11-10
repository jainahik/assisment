variable "sg_module_enabled" {
  description = "Whether this resource has to be created or not"
  default     = false
}

variable "instance_sg_name" {
  type        = string
  default     = ""
}

variable "sg_description" {
  type        = string
  description = "A description of this resource."
  default     = "ec2 instance security group"
}

variable "vpc_id" {
  description = "VPC id of the VPC"
  type        = string
  default     = ""
}

variable "ssh_ingress_rules" {
  description = "SSH ingress parameters for ec2 instance"
  type        = any
  default = []
}

variable "http_ingress_rules" {
  description = "http ingress parameters for ec2 instance"
  type        = any
  default = []
}

variable "egress_rules" {
  description = "http ingress parameters for ec2 instance"
  type        = list(map(string))
  default = []
}