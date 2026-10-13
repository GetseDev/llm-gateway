variable "name" {
  type = string
}

variable "limit" {
  type = number
}

variable "service" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "alert_emails" {
  type = list(string)
}

variable "thresholds" {
  type    = list(number)
  default = [50, 80, 100]
}