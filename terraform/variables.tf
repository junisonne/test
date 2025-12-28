# --- VARIABLEN (Konfigurierbar) ---

variable "vm_name" {
  type    = string
  default = "terraform-student-vm"
}

variable "cpu_cores" {
  type    = number
  default = 1
}

variable "ram_mb" {
  type    = number
  default = 2048
}

variable "key_pair_name" {
  type    = string
  default = "my-terraform-key"
}

variable "image_id" {
  type        = string
  description = "ID des Images (z.B. Ubuntu 22.04). Muss via `openstack image list` ermittelt werden."
  # BEISPIEL ID - BITTE ANPASSEN!
  default     = "2996c917-81ba-4bb3-8026-5b1b56d5e103" 
}

variable "volume_size" {
  type    = number
  default = 20 # GB
}

variable "delete_volume_on_termination" {
  type    = bool
  default = true
}

variable "network_name" {
  type        = string
  description = "Name des internen Netzwerks (muss bereits existieren!)"
  default     = "DHBW" # Anpassen an deine Umgebung!
}

variable "enable_floating_ip" {
  type    = bool
  default = true
}

variable "floating_ip_pool" {
  type        = string
  description = "Name des externen Netzwerks für Public IPs"
  default     = "DHBW" # Oder "ext-net", "DHBW", je nach Provider
}

variable "user_data_script" {
  type    = string
  default = <<-EOF
    #!/bin/bash
    echo "Hello from Terraform" > /var/tmp/hello.txt
  EOF
}