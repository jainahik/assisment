resource "aws_security_group" "ec2-sg" {
  count       = var.sg_module_enabled ? 1 : 0
  name        = var.instance_sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  ingress {
      from_port        = lookup(var.ssh_ingress_rules[count.index], "from_port", null)
      to_port          = lookup(var.ssh_ingress_rules[count.index], "to_port", null)
      protocol         = lookup(var.ssh_ingress_rules[count.index], "protocol", null)
      cidr_blocks      = lookup(var.ssh_ingress_rules[count.index], "cidr_blocks", null)
    }

  ingress {
      from_port        = lookup(var.http_ingress_rules[count.index], "from_port", null)
      to_port          = lookup(var.http_ingress_rules[count.index], "to_port", null)
      protocol         = lookup(var.http_ingress_rules[count.index], "protocol", null)
      cidr_blocks      = lookup(var.http_ingress_rules[count.index], "cidr_blocks", null)
    }

  egress {
      from_port        = lookup(var.egress_rules[count.index], "from_port", null)
      to_port          = lookup(var.egress_rules[count.index], "to_port", null)
      protocol         = lookup(var.egress_rules[count.index], "protocol", null)
      cidr_blocks      = ["0.0.0.0/0"]
    }

}