resource "aws_iam_role" "codedeploy_iam_role" {
    name               = "CodeDeployIamRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "codedeploy.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "codedeploy_service_policy" {
    name        = "CodeDeployServicePolicy"
    description = "Policy for CodeDeploy service role"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = [
                    "codedeploy:*",
                    "s3:Get*",
                    "s3:List*",
                    "ec2:Describe*",
                    "autoscaling:CompleteLifecycleAction",
                    "autoscaling:DeleteLifecycleHook",
                    "autoscaling:Describe*",
                    "autoscaling:PutLifecycleHook",
                    "autoscaling:RecordLifecycleActionHeartbeat",
                    "cloudwatch:DescribeAlarms",
                    "cloudwatch:PutMetricAlarm",
                    "cloudwatch:DeleteAlarms"
                ]
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role_attachment" {
    role       = aws_iam_role.codedeploy_iam_role.name
    policy_arn = aws_iam_policy.codedeploy_service_policy.arn
}

resource "aws_iam_instance_profile" "codedeploy-iam-role-profile" {
  name = "aws-iam-codedeploy-role-profile"
  role = aws_iam_role.codedeploy_iam_role.name
}