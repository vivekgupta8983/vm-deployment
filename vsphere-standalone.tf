#===============================================================================
# vSphere Provider
#===============================================================================

provider "vsphere" {
  version        = "1.11.0"
  vsphere_server = "${var.vsphere_vcenter}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}



#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vm_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# data "vsphere_virtual_machine" "data_disk_size" {
#   name          = "${var.data_disk_size}"
#   datacenter_id = "${data.vsphere_datacenter.dc.id}"
# }

data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}



#===============================================================================
# vSphere Resources
#===============================================================================

resource "vsphere_virtual_machine" "standalone" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.vm_cpu}"
  memory   = "${var.vm_ram}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "${var.vm_name}.vmdk"
    #size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    size             = "${var.disk_size != "" ? var.disk_size : data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${var.thin_provisioned != "" ? var.thin_provisioned : data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = "${var.vm_linked_clone}"

    customize {
      timeout = "20"

      linux_options {
        host_name = "${var.vm_name}"
        domain    = "${var.vm_domain}"
        user      = "${var.vm_user}"
        password  = "${var.vm_password}"
    
      }

      network_interface {
        ipv4_address = "${var.vm_ip}"
        ipv4_netmask = "${var.vm_netmask}"
      }

      ipv4_gateway    = "${var.vm_gateway}"
      dns_server_list = ["${var.vm_dns}"]
    }
  
  connection {
    type = "ssh"
    user = "${var.vm_user}"
    password = "${var.vm_password}"
    host = "${vsphere_virtual_machine.vm.default_ip_address}"
    port = "22"
    agent = false
    }

    # provisioner "file" {
    #   source = "files/volume.sh"
    #   destination = "/tmp/volume.sh"
    #   }

    # provisioner "remote-exec" {
    #   inline = [
    #     "chmod +x /tmp/volume.sh",
    #     "/tmp/volume.sh ${var.devpath}",
    #   ]
    #   }
    
  }
}
