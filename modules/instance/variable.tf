variable "ami" {
  type  = string
}

variable "instance_type" {
  type  = string
}
variable "sg_ec2_ids" {
  type  = list
}
variable "subnet_id" {
  type  = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type  = string
  default = ""
}
variable "user_data" {
  type = string
  default = ""
}
variable "target_group_arns" {
  type = list(string)
}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "isPortForwarding" {
  type = bool
  default = false
}
variable "ssh_allow_comm_list" {
  type = list(any)
}

# variable "db_name" {
#   description = "Name of the RDS database for WordPress"
#   type        = string
# }

# variable "db_user" {
#   description = "Username for the RDS database"
#   type        = string
# }

# variable "db_pass" {
#   description = "Password for the RDS database"
#   type        = string
#   sensitive   = true
# }

# variable "rds_endpoint" {
#   description = "RDS endpoint to be used in WordPress configuration"
#   type        = string
# }