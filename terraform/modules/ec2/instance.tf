resource "aws_instance" "app_server" {
    count = var.ec2_module_enabled ? 1 : 0
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [var.security_group]
    subnet_id = var.subnet_id
    associate_public_ip_address = true
    user_data = var.user_data
    tags = {
      Name = var.instance_name
    }
  }