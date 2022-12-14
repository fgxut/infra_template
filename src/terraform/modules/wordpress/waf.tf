resource "aws_wafv2_web_acl" "example_alb" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-alb-acl"
  description = "Web ACLs for ${var.common["env_abbr"]}-${var.common["name"]}-alb."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesWordPressRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesWordPressRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # rule {
  #   name     = "AWSManagedRulesCommonRuleSet"
  #   priority = 2

  #   override_action {
  #     none {}
  #   }

  #   statement {
  #     managed_rule_group_statement {
  #       name        = "AWSManagedRulesCommonRuleSet"
  #       vendor_name = "AWS"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "AWSManagedRulesCommonRuleSet"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # rule {
  #   name     = "AWSManagedRulesKnownBadInputsRuleSet"
  #   priority = 3

  #   override_action {
  #     none {}
  #   }

  #   statement {
  #     managed_rule_group_statement {
  #       name        = "AWSManagedRulesKnownBadInputsRuleSet"
  #       vendor_name = "AWS"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # rule {
  #   name     = "AWSManagedRulesLinuxRuleSet"
  #   priority = 4

  #   override_action {
  #     none {}
  #   }

  #   statement {
  #     managed_rule_group_statement {
  #       name        = "AWSManagedRulesLinuxRuleSet"
  #       vendor_name = "AWS"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "AWSManagedRulesLinuxRuleSet"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # rule {
  #   name     = "AWSManagedRulesSQLiRuleSet"
  #   priority = 5

  #   override_action {
  #     none {}
  #   }

  #   statement {
  #     managed_rule_group_statement {
  #       name        = "AWSManagedRulesSQLiRuleSet"
  #       vendor_name = "AWS"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "AWSManagedRulesSQLiRuleSet"
  #     sampled_requests_enabled   = true
  #   }
  # }

  # rule {
  #   name     = "AWSManagedRulesAmazonIpReputationList"
  #   priority = 6

  #   override_action {
  #     none {}
  #   }

  #   statement {
  #     managed_rule_group_statement {
  #       name        = "AWSManagedRulesAmazonIpReputationList"
  #       vendor_name = "AWS"
  #     }
  #   }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }

  tags = {
    Name       = "${var.common["env_abbr"]}-${var.common["name"]}-alb-acl"
    env        = var.common["env"]
  }
}

# あとで作成予定
# resource "aws_wafv2_web_acl_logging_configuration" "example_alb" {
#   log_destination_configs = [var.aws_s3_bucket["waf_acl_logs"].arn]
#   resource_arn            = aws_wafv2_web_acl.example_alb.arn
# }

resource "aws_wafv2_web_acl_association" "example_alb" {
  resource_arn = aws_lb.example.arn
  web_acl_arn  = aws_wafv2_web_acl.example_alb.arn
}
