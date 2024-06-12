output "instance_id" {
  description = "The unique identifier for the provisioned EC2 instance."
  value       = aws_instance.Test-ec2.id
}

output "instance_type" {
  description = "The type of EC2 instance (e.g., t2.micro, m5.large)."
  value       = aws_instance.Test-ec2.instance_type
}

output "instance_state" {
  value = aws_instance.Test-ec2.instance_state
}
output "public_dns" {
  description = "The public DNS name assigned to the EC2 instance."
  value       = aws_instance.Test-ec2.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the EC2 instance."
  value       = aws_instance.Test-ec2.public_ip
}

output "private_dns" {
  description = "The private DNS name assigned to the EC2 instance within its VPC."
  value       = aws_instance.Test-ec2.private_dns
}

output "private_ip" {
  description = "The private IP address assigned to the EC2 instance within its VPC."
  value       = aws_instance.Test-ec2.private_ip
}