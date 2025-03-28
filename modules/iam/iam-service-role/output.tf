output "codedeploy-iam-role-profile" {
  value = aws_iam_instance_profile.codedeploy-iam-role-profile
}
output "codedeploy-iam-role-name" {
  value = aws_iam_role.codedeploy_iam_role.name
}

output "codedeploy_iam_role_arn" {
  value = aws_iam_role.codedeploy_iam_role.arn
}
