output "instance_id" {
  value = aws_instance.ec2.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg_comm.id
}

output "instance_az" {
  value = aws_instance.ec2.availability_zone
}

output "instance_ids" {
  value = aws_instance.ec2[*].id
}
