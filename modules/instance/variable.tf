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