variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Name of Application"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment"
  type        = string
  default     = ""
}
