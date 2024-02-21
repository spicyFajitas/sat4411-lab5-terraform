# SAT 4411 Lab 5 - Terraform and VM Automation

Right now the files are in a good state to where you can run the plan and apply commands and they will run without errors. You'll have to create a `terraform.tfvars` file and add in the credentials for the vCenter instance.

```tf
# terraform.tfvars
# set of VM values of variables
vsphere_server     = "172.20.191.56"
vsphere_user       = "username"
vsphere_password   = "password"
```

After running `terraform plan` and `terraform apply`, you'll need to manually go into the vCenter instance and delete the TinyCore-tf VM that is created as you can't run the script again without errors after the VM is created.

## Commands

```
# initialize provider and terraform working folder
terraform init

# plan changes (make sure syntax is right)
terraform plan

# apply changes
terraform apply
```
