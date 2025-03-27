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

# Please check if this matches your platform-policy-new1.json
resource "aws_iam_policy" "platform_policy_new_01" {
  name        = "policy-1"
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
