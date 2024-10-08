# #Create SCP for Management-Custom-OU to restrict launching EC2's type other than t2.micro
# data "aws_iam_policy_document" "scp-allow-ec2-microType-only" {
#   statement {
#     effect    = "Deny"
#     actions   = ["ec2:RunInstances"]
#     resources = ["arn:aws:ec2:*:*:instance/*"]

#     condition {
#       test = "ForAnyValue:StringNotEquals"
#       values = ["t2.micro"]
#       variable = "ec2:InstanceType"
#     }
#   }
# }

# resource "aws_organizations_policy" "scp-allow-ec2-microType-only" {
#   name    = "AllowOnlyEc2MicroTypeOnly"
#   content = data.aws_iam_policy_document.scp-allow-ec2-microType-only.json
# }

# resource "aws_organizations_policy_attachment" "secondAccount" {
#   policy_id = aws_organizations_policy.scp-allow-ec2-microType-only.id
#   target_id = "${data.aws_caller_identity.current.account_id}"
# }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}