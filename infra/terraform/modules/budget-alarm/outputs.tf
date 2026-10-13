output "id" {
  description = "ID del budget (formato account_id:name)."
  value       = aws_budgets_budget.budget.id
}

output "arn" {
  description = "ARN del budget."
  value       = aws_budgets_budget.budget.arn
}

output "name" {
  description = "Nombre del budget."
  value       = aws_budgets_budget.budget.name
}
