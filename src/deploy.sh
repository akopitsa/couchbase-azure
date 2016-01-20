###
###
### AZURE CLI COMMANDS
###
###

#login
#azure login

# set account to use
azure account set "Azure Pass"

# set cli to use ARM template mode
azure config mode arm

#delete deplyment/reset azure:
azure group deployment stop cb-group -n "azure-cb-deployment"
azure group deployment delete cb-group -n "azure-cb-deployment"
azure group delete cb-group

# create resource group and set location for Resource Group
azure group create -n "cb-group" -l "West US"

#create deployment and wait for success
azure group deployment create --template-uri https://raw.githubusercontent.com/martinesmann/couchbase-azure/master/src/templates/azuredeploy.json -e templates/azuredeploy.parameters.json cb-group azure-cb-deployment

#tunnel test/ jump box tunneling
#ssh -D 8080 -C -N couchadmin@23.97.70.248