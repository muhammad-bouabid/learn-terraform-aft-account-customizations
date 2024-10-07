#Create SCP for Management-Custom-OU to restrict launching EC2's type other than t2.micro
data "aws_iam_policy_document" "scp-allow-ec2-microType-only" {
  statement {
    effect    = "Deny"
    actions   = ["ec2:RunInstances"]
    resources = ["arn:aws:ec2:*:*:instance/*"]

    condition {
      test = "ForAnyValue:StringNotEquals"
      values = ["t2.micro"]
      variable = "ec2:InstanceType"
    }
  }
}

resource "aws_organizations_policy" "scp-allow-ec2-microType-only" {
  name    = "AllowOnlyEc2MicroTypeOnly"
  content = data.aws_iam_policy_document.scp-allow-ec2-microType-only.json
}

resource "aws_organizations_policy_attachment" "secondAccount" {
  policy_id = aws_organizations_policy.scp-allow-ec2-microType-only.id
  target_id = "${data.aws_caller_identity.current.account_id}"
}