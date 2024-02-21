#VMware vSphere Provider
provider "vsphere" {  
  #Set of variables used to connect to the vCenter
    vsphere_server = var.vsphere_server 
    user           = var.vsphere_user
    password       = var.vsphere_password
  
#If you have a self-signed cert
    allow_unverified_ssl = true
  }
  
#Name of the Datacenter in the vCenter
data "vsphere_datacenter" "dc" {
    name = "Group12"
  }
#Name of the Cluster in the vCenter
data "vsphere_compute_cluster" "cluster" {
    name          = "SAT4411"
    datacenter_id = data.vsphere_datacenter.dc.id
  }
#Name of the Datastore in the vCenter, where VM will be deployed
data "vsphere_datastore" "datastore" {
    name          = "Group 12 Datastore"
    datacenter_id = data.vsphere_datacenter.dc.id
  }
#Name of the Portgroup in the vCenter, to which VM will be attached
data "vsphere_network" "network" {
    name          = "VM Network"
    datacenter_id = data.vsphere_datacenter.dc.id
  }

#Name of the Template in the vCenter, which will be used to the deployment
data "vsphere_virtual_machine" "template" {
    name          = "TinyCore"
    datacenter_id = data.vsphere_datacenter.dc.id
  }

# data "vsphere_content_library_item" "item" {
#   name       = "TinyCore Template"
#   type       = "vm-template"
#   library_id = data.vsphere_content_library.name
# }

#Set VM parameteres
  resource "vsphere_virtual_machine" "TinyCore-tf" {
    count = 98
    name = "TinyCore-tf-0${count.index+1}"
    guest_id = "otherLinuxGuest"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id     = data.vsphere_datastore.datastore.id
    # num_cpus = 1
    # memory   = 160
    folder = "Terraform"
    wait_for_guest_net_timeout = -1
    wait_for_guest_ip_timeout  = -1
    network_interface {
      network_id = data.vsphere_network.network.id
    }
  
    disk {
      label            = "disk0"
      thin_provisioned = true
      size             = 1
    }

    cdrom {
      datastore_id = data.vsphere_datastore.datastore.id
      path         = "/contentlib-6cc2a390-34fd-45f5-85ab-861df4d5a085/34d11765-de2b-4c4d-95c3-7a5ccf1f5506/TinyCore-14.0_a2015ad7-54b9-4c7f-8d14-1b17edf57941.iso"
    }
  
    clone {
      template_uuid       = data.vsphere_virtual_machine.template.id
      
      # Linux_options are required section, while deploying Linux virtual machines
#       customize {
#         linux_options {
#           host_name = "TinyCore-tf-0${count.index+1}"
#           domain = "local.cnsanet"
#         }
#           network_interface {
#             ipv4_address = "172.20.189"
#             ipv4_netmask = "24"
#           }
# #There are a global parameters and need to be outside linux_options section. If you put IP Gateway or DNS in the linux_options, these will not be added
#         ipv4_gateway = "172.20.188.1"
#         dns_server_list = ["172.20.188.1"]
#         dns_suffix_list = ["local.cnsanet"]
#       }
    }
  }
# #Outup section will display vsphere_virtual_machine.ubu-testing Name and IP Address
# output "VM_Name" {
#   value = vsphere_virtual_machine.TinyCore-tf.name
# }

# output "VM_IP_Address" {
#   value = vsphere_virtual_machine.TinyCore-tf.guest_ip_addresses
# }