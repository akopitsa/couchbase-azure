#Couchbase with Azure ARM Templates
This blog post describes how to set up your own Couchbase Cluster using Azure Resource Manager templates, aka ARM templates.

##Prerequisites: 
You will need a few things to follow along and create your own Couchbase Cluster in Azure.

1. Azure Subscription
2. Azure CLI, installed on your system 

##Azure CLI

###Authentication
Before using the Azure CLI we need to authenticate against Microsoft Azure. There are multiple ways to authenticate the CLI with Azure, for a detailed guide visit [Connect to an Azure](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-connect/).

In this guide we will use this command:

```
azure login
```

*Please follow the on screen instructions to authenticate the Azure CLI.*

####Set the Azure Resource Manager mode
The Azure Resource Manager mode is not enabled by default, use the following command to enable Azure CLI Resource Manager commands.

```
azure config mode arm
```

#Create a Resource Group
```
azure group create -n CB_RESOURCE_GROUP -l "West US"
```
#Create a deployment and wait for success

```
azure group deployment create --template-uri https://raw.githubusercontent.com/martinesmann/couchbase-azure/master/src/templates/azuredeploy.json \
    -e templates/azuredeploy.parameters.json \
    CB_RESOURCE_GROUP AZURE_DEPLOYMENT
```
#Public IP for Resource Group
```
azure network public-ip list $AZURE_RESOURCE_GROUP_NAME
```