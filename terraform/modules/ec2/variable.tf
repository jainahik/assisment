variable "ec2_module_enabled" {
  description = "Whether this resource has to be created or not"
  default     = false
}

variable "ami_id" {
  description = "AMI to use for the instance."
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  type        = string
  default     = "t2-micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance."
  type        = string
  default     = "test_aws_key"
}

variable "subnet_id" {
  description = "subnet id."
  type        = string
  default     = ""
}

variable "public_ip_address" {
  description = "Whether to assign public ip address."
  type        = bool
  default     = "false"
}

variable "security_group" {
  description = "Security group for the instance."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC id after creation of VPC"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "Linux shell commands"
  type        = any
  default     = ""
}