# tests/budget-alarm.tftest.hcl
mock_provider "aws" {}

variables {
  name         = "budget-alarm-test"
  limit        = 100
  service      = "AmazonEC2"
  tags         = { Environment = "test" }
  alert_emails = ["demo@gmail.com"]
  thresholds   = [50, 80, 100]
}

run "crea_budget_mensual_en_usd" {
  command = plan

  assert {
    condition     = aws_budgets_budget.budget.limit_amount == "100"
    error_message = "limit_amount debe ser el límite convertido a string."
  }

  assert {
    condition     = aws_budgets_budget.budget.time_unit == "MONTHLY" && aws_budgets_budget.budget.limit_unit == "USD"
    error_message = "El budget debe ser mensual y en USD."
  }
}

run "una_notificacion_por_threshold" {
  command = plan

  assert {
    condition     = length(aws_budgets_budget.budget.notification) == 3
    error_message = "Debe haber una notificación por cada threshold."
  }
}

run "sin_service_no_filtra_por_servicio" {
  command = plan

  variables {
    service = null
  }

  assert {
    condition     = length([for f in aws_budgets_budget.budget.cost_filter : f if f.name == "Service"]) == 0
    error_message = "Sin service no debe haber cost_filter de Service."
  }
}

run "sin_tags_no_filtra_por_tags" {
  command = plan

  variables {
    tags = {}
  }

  assert {
    condition     = length([for f in aws_budgets_budget.budget.cost_filter : f if f.name == "TagKeyValue"]) == 0
    error_message = "Sin tags no debe haber cost_filter de TagKeyValue."
  }
}
