variable "name" {
  description = "(Required) Specifies the name of the Logic Application"
  type        = string
  default     = "p-sol-alpha"
}

variable "location" {
  description = "(Optional) Specifies the location of the Logic Application"
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the Logic Application"
  type        = map(any)
  default = {
    Environment   = "dev"
    ManagedBy     = "terraform"
    Repo          = "terraform-component-lz-scaffolding"
    Configuration = "2022-07-19-1345"
  }
}
