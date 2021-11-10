provider "aws" {
    region = "us-east-2"
}


/******************************************
	VPC Module
******************************************/
module "test_vpc" {
  source             = "../modules/vpc"
  vpc_module_enabled = true
  name               = "abhi-test"
  vpc_cidr           = "10.41.0.0/16"
  vpc_id             = module.test_vpc.vpc_id
  pub_subnet_cidr    = ["10.41.1.0/24", "10.41.2.0/24"]
  priv_subnet_cidr   = ["10.41.3.0/24", "10.41.4.0/24"]
  availability_zones = ["us-east-2a", "us-east-2b"]
  tags = {
    Owner       = "abc-corp"
    Environment = "dev"
  }
}

/******************************************
	Security Group Module
******************************************/
module "sec_group" {
    source            = "../modules/sec-group"
    sg_module_enabled = true
    vpc_id            = module.test_vpc.vpc_id
    instance_sg_name  = "app-server-sg"
 
    # ssh ingress rules
    ssh_ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
  # http ingress rule
  http_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
  # egress rules
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}


/******************************************
	EC2 Module
******************************************/
module "ec2" {
    source               = "../modules/ec2"
    ec2_module_enabled   = true
    ami_id               = "ami-0f19d220602031aed"
    instance_type        = "t2.micro"
    key_name             = "test_aws_key"
    subnet_id            = module.test_vpc.pub_subnet_id.0
    security_group       = module.sec_group.security_group
    public_ip_address    = true
    instance_name        = "app-server"
    user_data = <<EOF
      #!/bin/bash
      sudo yum install httpd -y
      echo 'Hello Abhishek' > /var/www/html/index.html
      sudo systemctl start httpd
    EOF
}