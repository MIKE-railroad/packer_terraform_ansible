variable "vm_name" {
  type = string
}

variable "memory" {
  type    = number
  default = 4096
}

variable "cpu" {
  type    = number
  default = 2
}

variable "generation" {
  type    = number
  default = 2
}

variable "switch_name" {
  type = string
}

variable "vhd_path" {
  type = string
}

variable "template_path" {
  type = string
}
