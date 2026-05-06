output "web_instance_id" {
  value = aws_instance.web.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
