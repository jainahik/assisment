output "security_group" {
  value = aws_security_group.ec2-sg.0.id
}
