
#* For powershell login
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Connect-AzAccount
#* For Az Cli login
az login --use-device-code

# Terraform execution   
terraform init
terraform validate
terraform plan
terraform destroy -auto-approve

# manage state
terraform state list
terraform state show #<completeName>

##> Input variables files
# Terraform also automatically loads a number of variable definitions files if they are present:
# Files named exactly terraform.tfvars or terraform.tfvars.json.
# Any files with names ending in .auto.tfvars or .auto.tfvars.json

#variables in different file:
terraform plan -var-file dev.tfvars -out try01.tfplan
# Destroy 
terraform destroy -var-file dev.tfvars -auto-approve
