variable "codedeploy_app_name" {
  description = "CodeDeploy Application Name"
  type        = string
}

variable "codedeploy_deployment_group_name" {
  description = "CodeDeploy Deployment Group Name"
  type        = string
}

variable "codedeploy_service_role_arn" {
  description = "IAM Role ARN for CodeDeploy"
  type        = string
}

variable "ec2_tag_key" {
  description = "EC2 Tag Key used for CodeDeploy"
  type        = string
}

variable "ec2_tag_value" {
  description = "EC2 Tag Value used for CodeDeploy"
  type        = string
}
