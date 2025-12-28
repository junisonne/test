output "instance_ip" {
  description = "Internal IP address of the VM"
  value       = openstack_compute_instance_v2.vm.access_ip_v4
}

output "floating_ip" {
  description = "Public floating IP (if enabled)"
  value       = var.enable_floating_ip ? openstack_networking_floatingip_v2.fip[0].address : "Not assigned"
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = var.enable_floating_ip ? "ssh ubuntu@${openstack_networking_floatingip_v2.fip[0].address}" : "ssh ubuntu@${openstack_compute_instance_v2.vm.access_ip_v4}"
}

output "instance_id" {
  description = "OpenStack instance ID"
  value       = openstack_compute_instance_v2.vm.id
}

output "flavor_name" {
  description = "OpenStack flavor used"
  value       = data.openstack_compute_flavor_v2.selected.name
}

output "vm_specs" {
  description = "VM specifications"
  value       = "${var.cpu_cores} vCPU, ${var.ram_mb}MB RAM, ${var.volume_size}GB disk"
}
