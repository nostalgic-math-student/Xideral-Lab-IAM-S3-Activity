output "lambda_user_name" {
  value = aws_iam_user.lambda_user.name
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_policy_arn" {
  value = aws_iam_policy.lambda_full_access_policy.arn
}