resource "aws_iam_group" "lambda_full_access_group" {
  name = "lambda_full_access_group"
}

resource "aws_iam_user" "lambda_user" {
  name = "lambda_user"
}

resource "aws_iam_user_group_membership" "lambda_user_group_membership" {
  user   = aws_iam_user.lambda_user.name
  groups = [aws_iam_group.lambda_full_access_group.id]
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_full_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_full_access_policy" {
  name        = "LambdaFullAccessPolicy"
  description = "Full access to AWS Lambda"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "iam:PassRole"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_full_access_policy_attachment" {
  name       = "lambda_full_access_policy_attachment"
  policy_arn = aws_iam_policy.lambda_full_access_policy.arn
  groups     = [aws_iam_group.lambda_full_access_group.name]
}

resource "aws_iam_user_policy_attachment" "lambda_user_full_access" {
  user       = aws_iam_user.lambda_user.name
  policy_arn = aws_iam_policy.lambda_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_role_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_full_access_policy.arn
}