provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "account_id" {
  description = "The AWS account ID where resources will be created."
  type        = string
}

variable "agency_code" {
  description = "The AWS account ID where resources will be created."
  type        = string
  default     = "EG"
}

variable "example_user" {
  description = "The AWS account user where resources will be created."
  type        = string
  default     = null
}

variable "example_group" {
  description = "The AWS account group where resources will be created."
  type        = string
  default     = null
}

data "aws_vpc_endpoint" "sts" {
  filter {
    name   = "service-name"
    values = ["com.amazonaws.${var.aws_region}.sts"]
  }
}

output "sts_vpce_endpoint" {
  value = data.aws_vpc_endpoint.sts.dns_entry
}

data "aws_vpc_endpoint" "logs" {
  filter {
    name   = "service-name"
    values = ["com.amazonaws.${var.aws_region}.logs"]
  }
}

output "logs_vpce_endpoint" {
  value = data.aws_vpc_endpoint.logs.dns_entry
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "cwl-${var.account_id}-cloudtrail"
  retention_in_days = 365
}

# Create IAM group
resource "aws_iam_group" "example_group" {
  name = var.example_group != null ? var.example_group : "${var.agency_code}_ABLR_CloudWatch_Group"
}

# Attach user to group
resource "aws_iam_user_group_membership" "example_user_group_membership" {
  user = aws_iam_user.example_user.name
  groups = [aws_iam_group.example_group.name]
}

# Optional - Attach a policy to the group
resource "aws_iam_group_policy" "allow_ec2_hf_access_aws_services" {
  name        = "${var.agency_code}_ABLR_CloudWatchAccess"
  description = "The iam policy is meant to attach to iam user which pushes cloudtrail logs to ABLR"

  group = aws_iam_group.example_group.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:SendMessage",
          "sqs:DeleteMessage",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets",
          "s3:GetBucketTagging", 
          "s3:GetAccelerateConfiguration", 
          "s3:GetBucketLogging", 
          "s3:GetLifecycleConfiguration", 
          "s3:GetBucketCORS",
          "config:DeliverConfigSnapshot",
          "config:DescribeConfigRules",
          "config:DescribeConfigRuleEvaluationStatus",
          "config:GetComplianceDetailsByConfigRule",
          "config:GetComplianceSummaryByConfigRule",
          "iam:GetUser",
          "iam:ListUsers",
          "iam:GetAccountPasswordPolicy",
          "iam:ListAccessKeys",
          "iam:GetAccessKeyLastUsed", 
          "autoscaling:Describe*",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "sns:Get*",
          "sns:List*",
          "sns:Publish",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "ec2:DescribeInstances",
          "ec2:DescribeReservedInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeRegions",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DescribeImages",
          "ec2:DescribeAddresses",
          "lambda:ListFunctions",
          "rds:DescribeDBInstances",
          "cloudfront:ListDistributions",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeInstanceHealth",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeListeners",
          "inspector:Describe*",
          "inspector:List*",
          "kinesis:Get*",
          "kinesis:DescribeStream",
          "kinesis:ListStreams",
          "kms:Decrypt",
          "sts:AssumeRole"
        ],
        "Sid": "AllowEC2ToAccessAWSServices",
        "Effect": "Allow",
        "Resource": [
          "arn:aws:logs:ap-southeast-1:${var.account_id}:log-group:cwl-${var.account_id}-cloudtrail:*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "example_user" {
  name = var.example_user != null ? var.example_user : "${var.agency_code}_ABLR_CloudWatch"
}

resource "aws_iam_access_key" "example_access_key" {
  user = aws_iam_user.example_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.example_access_key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.example_access_key.secret
}
