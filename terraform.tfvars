#===============================================================================
# VMware vSphere configuration
#===============================================================================

# vCenter IP or FQDN #
vsphere_vcenter = "192.168.1.23"

# vSphere username used to deploy the infrastructure #
vsphere_user = "administrator@vsphere.lab"

vsphere_password = "Cont@ct@123"
# Skip the verification of the vCenter SSL certificate (true/false) #
vsphere_unverified_ssl = "true"

# vSphere datacenter name where the infrastructure will be deployed #
vsphere_datacenter = "Datacenter"

# vSphere cluster name where the infrastructure will be deployed #
vsphere_cluster = "Mig-infra-akash-cluster"

#===============================================================================
# Virtual machine parameters
#===============================================================================

# The name of the virtual machine #
vm_name = "ubuntu"

# The datastore name used to store the files of the virtual machine #
vm_datastore = "datastore1"

# The vSphere network name used by the virtual machine #
vm_network = "VM Network"

# The netmask used to configure the network card of the virtual machine (example: 24) #
vm_netmask = "24"

# The network gateway used by the virtual machine #
vm_gateway = "192.168.1.1"

# The DNS server used by the virtual machine #
vm_dns = "192.168.0.109"

# The domain name used by the virtual machine #
vm_domain = ""

# The vSphere template the virtual machine is based on #
vm_template = "ubuntu-16-templete"

# Use linked clone (true/false)
vm_linked_clone = "false"

# The number of vCPU allocated to the virtual machine #
vm_cpu = "1"

# The amount of RAM allocated to the virtual machine #
vm_ram = "1024"

# The IP address of the virtual machine #
vm_ip = "192.168.1.52"

#Size of your vm's in GB
disk_size = "100"

#disk provisioning true or false
# thin_provisioned = "true"

vm_user = "ubuntu"

vm_password = "ROOT#123"
