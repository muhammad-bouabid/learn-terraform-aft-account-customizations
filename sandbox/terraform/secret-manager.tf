# Creating an AWS Secret for API Service User
resource "aws_secretsmanager_secret" "custom-secret-manager" {
  name                    = "service_user"
  description             = "Service Account Username for the API"
  recovery_window_in_days = 0
  tags = {
    Environment = "sandbox"
  }
}


resource "aws_secretsmanager_secret_version" "custom-secret-manager" {
  secret_id = aws_secretsmanager_secret.custom-secret-manager.id
  secret_string = "secret value for sandbox-${data.aws_caller_identity.current.account_id}"
}