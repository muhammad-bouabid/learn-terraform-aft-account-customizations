resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "SecretsManagerPolicy"
  path        = "/"
  description = "My test policy"


  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:ListSecrets",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
})
}

resource "aws_iam_role" "secrets_manager_role" {
  name               = "SecretsManagerAccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        AWS = "${data.aws_caller_identity.current.arn}"
      }
    }]
  })
}


resource "aws_iam_policy_attachment" "secrets_manager_attachment" {
  name       = "SecretsManagerPolicyAttachment"
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  roles      = [aws_iam_role.secrets_manager_role.name]
}
