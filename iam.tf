resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "tf_role" {
  name = "tf_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::343218211173:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            "token.actions.githubusercontent.com:sub" : [
              "repo:lucmoraees/github-actions-ci-rocketseat:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ecr_app_permision"

    policy = jsonencode({
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid" = "Statement1",
          "Action" : "ecr:*",
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" = "Statement2",
          "Action" : "iam:*"
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    })
  }

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "app_runner_role" {
  name = "app_runner_role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "build.apprunner.amazonaws.com"
        }
        Action : "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::343218211173:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            "token.actions.githubusercontent.com:sub" : [
              "repo:lucmoraees/github-actions-ci-rocketseat:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ecr_app_permision"

    policy = jsonencode({
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid" = "Statement1",
          "Action" : "apprunner:*",
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" = "Statement2",
          "Action" : [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid"    = "Statement3",
          "Effect" = "Allow",
          "Action" = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:ListTagsForResource",
            "ecr:DescribeImageScanFindings",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage"
          ],
          "Resource" = "*"
        }
      ]
    })
  }

  tags = {
    IAC = "True"
  }
}