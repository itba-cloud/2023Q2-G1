variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "bucket_access_OAI" {
  description = "OAI of authorized bucket accessors"
  type        = list(string)
}

variable "vpc_ids" {
  description = "vpc endpoints ids of authorized bucket accessors"
  type        = list(string)
}

variable "versioning" {
  type        = string
  description = "Status of the versioning"
  default     = ""
}

variable "redirect_all_requests_to" {
  type        = any
  description = "Object redirect all request to"
  default     = null

}

variable "objects" {
  type        = list(any)
  description = "Objects for the bucket"
  default     = []
}
variable "lifecycle_rule" {
  type        = list(any)
  description = "lifecycle_rule for the bucket"
  default     = []
}

variable "bucket_policy_read" {
  type        = bool
  description = "Boolean value that shows if the bucket have policy read"
  default     = false
}

variable "logs" {
  type        = string
  description = "Bucket to save the logs"
  default     = ""
}

variable "actions" {
  type        = list(string)
  description = "Actions for the policy"
  default     = []
}