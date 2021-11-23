
output "instance1_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web-server-1.public_ip
}
/*
output "instance2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web-server-2.public_ip
}

output "alb-dns-name" {
  description = "alb dns name"
  value = aws_lb.web-lb.dns_name
}
*/