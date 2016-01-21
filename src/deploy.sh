###
###
### AZURE CLI COMMANDS
###
###

#VARIABLES

AZURE_ACCOUNT="Azure Pass"
AZURE_DEPLOYMENT_NAME="cb-deployment"
AZURE_RESOURCE_GROUP_NAME="cb-group"
AZURE_LOCATION="West US"

#login
#azure login

# set account to use
azure account set "$AZURE_ACCOUNT"

# set cli to use ARM template mode
azure config mode arm

#delete deplyment/reset azure:
yes y | azure group deployment stop   $AZURE_RESOURCE_GROUP_NAME -n $AZURE_DEPLOYMENT_NAME 
yes y | azure group deployment delete $AZURE_RESOURCE_GROUP_NAME -n $AZURE_DEPLOYMENT_NAME 
yes y | azure group delete $AZURE_RESOURCE_GROUP_NAME

# create resource group and set location for Resource Group
azure group create -n $AZURE_RESOURCE_GROUP_NAME -l "$AZURE_LOCATION"

#create deployment and wait for success
azure group deployment create --template-uri https://raw.githubusercontent.com/martinesmann/couchbase-azure/master/src/templates/azuredeploy.json \
    -e templates/azuredeploy.parameters.json \
    $AZURE_RESOURCE_GROUP_NAME $AZURE_DEPLOYMENT_NAME

#get public ip for resource group
azure network public-ip list $AZURE_RESOURCE_GROUP_NAME

#tunnel test/ jump box tunneling
#ssh -D 8080 -C -N couchadmin@23.97.70.248


###
### NOTES
###
### /opt/couchbase/bin/couchbase-cli node-init -c 10.0.0.10:8091 -u "couchadmin" -p "P@ssword1" --node-init-data-path="/datadisks/disk1/couchbase" --node-init-index-path="/datadisks/disk1/couchbase"
###"/datadisks/disk1/couchbase"
###
###
### Couchbase CLI notes
###
### http://developer.couchbase.com/documentation/server/4.1/cli/cbcli/node-init.html
### 