# azure cli commands

#login
azure login

# set account to use
azure account set "Azure Pass"

# set cli to use ARM template mode
azure config mode arm

# create resource group and set location for Resource Group
azure group create -n "cb-group" -l "West US"

#create deployment and wait for success
azure group deployment create --template-uri https://raw.githubusercontent.com/martinesmann/couchbase-azure/master/src/templates/azuredeploy.json -e templates/azuredeploy.parameters.json cb-group azure-cb-deployment





