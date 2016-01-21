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