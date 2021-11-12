output "instance_ip" {
  value = aws_instance.app_server.0.public_ip
}
