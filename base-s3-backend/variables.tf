# Configuration Variables
variable "dynamodb_table" {
  description = "The name of the Dynamodb table for locking the state file"
}

variable "bucket_name" {
  description = "The S3 bucket name to save the state file remotely"
}




