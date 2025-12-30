terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}


# Provider Konfiguration
# Erwartet Umgebungsvariablen (OS_AUTH_URL, OS_USERNAME, etc.)
# oder eine clouds.yaml
provider "openstack" {
  cloud = "openstack"
}

# --- DATA SOURCES & RESOURCES ---

# 1. Flavor (Hardware-Größe) automatisch finden
data "openstack_compute_flavor_v2" "selected" {
  vcpus    = var.cpu_cores
  min_ram  = var.ram_mb
  min_disk = 10
}

# 2. Security Group für SSH
resource "openstack_networking_secgroup_v2" "ssh_access" {
  # ÄNDERUNG: Workspace im Namen
  name        = "${var.vm_name}-${terraform.workspace}-ssh-access"
  description = "Security group for SSH access created by Terraform"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_access.id
}

# 3. SSH Key hochladen
resource "openstack_compute_keypair_v2" "ssh_key" {
  # ÄNDERUNG: Workspace im Namen, damit Keys nicht kollidieren
  name       = "${var.key_pair_name}-${terraform.workspace}"
  public_key = file("./student-key.pub")
}

# 4. Die VM Instanz
resource "openstack_compute_instance_v2" "vm" {
  # ÄNDERUNG: Workspace im VM-Namen
  name            = "${var.vm_name}-${terraform.workspace}"
  flavor_id       = data.openstack_compute_flavor_v2.selected.id
  
  key_pair        = openstack_compute_keypair_v2.ssh_key.name
  
  security_groups = [
    openstack_networking_secgroup_v2.ssh_access.name, 
    "default"
  ]
  
  # Boot from Volume
  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = var.delete_volume_on_termination
    volume_size           = var.volume_size
  }

  # Netzwerk Verbindung
  network {
    name = var.network_name
  }

  metadata = {
    managed_by = "terraform"
    created_at = timestamp()
  }

  user_data = var.user_data_script
}

# 5. Floating IP reservieren (Optional)
resource "openstack_networking_floatingip_v2" "fip" {
  count = var.enable_floating_ip ? 1 : 0
  pool  = var.floating_ip_pool
  description = "Public IP for ${var.vm_name}"
}

# 6. Floating IP zuweisen (FIXED VERSION)
resource "openstack_networking_floatingip_associate_v2" "fip_attach" {
  count       = var.enable_floating_ip ? 1 : 0
  
  floating_ip = openstack_networking_floatingip_v2.fip[0].address
  
  # Wir holen uns die Port-ID direkt aus der erstellten VM
  port_id     = openstack_compute_instance_v2.vm.network[0].port
}
