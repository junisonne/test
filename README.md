# Hello VM Template

Simple Ubuntu virtual machine for testing and learning Terraform deployments.

## What gets deployed

- 1x Ubuntu 22.04 LTS VM
- Optional floating IP for external access
- SSH key for access
- Security group allowing SSH

## Prerequisites

- OpenStack credentials configured
- SSH key pair generated

## Usage

1. Select this template in the AppStore
2. Configure parameters:
   - **vm_name**: Choose a name for your VM
   - **instance_type**: Select VM size (tiny, small, medium)
   - **enable_floating_ip**: Enable for external access
3. Deploy
4. Access your VM via SSH using the provided command

## Outputs

After deployment, you'll receive:
- **instance_ip**: Internal IP address
- **floating_ip**: Public IP (if enabled)
- **ssh_command**: Ready-to-use SSH command

## Terraform Details

This template uses:
- `openstack_compute_instance_v2` for VM
- `openstack_networking_floatingip_v2` for public IP (optional)
- `openstack_compute_floatingip_associate_v2` for IP association

## Cleanup

To destroy the infrastructure, use the "Destroy" button in the AppStore.
