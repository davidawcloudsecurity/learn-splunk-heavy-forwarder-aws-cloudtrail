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

data "aws_vpc_endpoint" "sts" {
  filter {
    name   = "service-name"
    values = ["com.amazonaws.${var.aws_region}.sts"]
  }
}

output "sts_vpce_endpoint" {
  value = data.aws_vpc_endpoint.sts.dns_entry
}

data "aws_vpc_endpoint" "log" {
  filter {
    name   = "service-name"
    values = ["com.amazonaws.${var.aws_region}.log"]
  }
}

output "log_vpce_endpoint" {
  value = data.aws_vpc_endpoint.log.dns_entry
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "cwl-${var.account_id}-cloudtrail"
  retention_in_days = 7
}

# Please check if this matches your platform-policy-new1.json
resource "aws_iam_policy" "allow_ec2_hf_access_aws_services" {
  name        = "EC2_HF_Access_AWS_Services"
  description = "Example IAM Policy"
  policy      = jsonencode({
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
        "Effect": "Allow",
        "Resource": [
          "arn:aws:logs:ap-southeast-1:${var.account_id}:log-group:cwl-${var.account_id}-cloudtrail:*"
        ]
      }
    ]
  })
}
