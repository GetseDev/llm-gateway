resource "aws_budgets_budget" "budget" {
  name         = var.name
  budget_type  = "COST"
  limit_amount = tostring(var.limit)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "cost_filter" {
    for_each = var.service != null ? [var.service] : []
    content {
      name   = "Service"
      values = [cost_filter.value]
    }
  }

  dynamic "cost_filter" {
    for_each = length(var.tags) > 0 ? [var.tags] : []
    content {
      name   = "TagKeyValue"
      values = [for key, value in cost_filter.value : "user:${key}${"$"}${value}"]
    }
  }

  dynamic "notification" {
    for_each = var.thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = var.alert_emails
    }
  }

}
