#Couchbase with Azure ARM Templates
This blog post describes how to set up your own Couchbase Cluster using Azure Resource Manager templates, aka ARM templates.

##Prerequisites: 
You will need a few things to follow along and create your own Couchbase Cluster in Azure.

1. Azure Subscription
2. Azure CLI, installed on your system
3. Github account, optional if you would like to experiment with your own ARM templates.

##Azure Resource Manager templates
Azure Resource Manager allows you to provision applications to Microsoft Azure using a declarative template. With a single single template, you can deploy multiple services along with their dependencies. You also have the option to split up your ARM templates into multiple templates that each describe individual resources. You can use the same templates individually or separately to repeatedly deploy your application/resources during every stage of the application lifecycle.

You can compare AMR templates to other resource description technologies like [chef.io](https://docs.chef.io/resource_template.html) or others.



Here is an example of the most simple ARM template:

```
{
   "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
   "contentVersion": "",
   "parameters": {  },
   "variables": {  },
   "resources": [  ],
   "outputs": {  }
}
``` 

##Azure CLI

###Authentication
Before using the Azure CLI we need to authenticate against Microsoft Azure. There are multiple ways to authenticate the CLI with Azure, for a detailed guide visit [Connect to an Azure](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-connect/).

In this guide we will use this command:

```
azure login
```

*Please follow the on screen instructions to authenticate the Azure CLI.*

###Set Azure Subscription Account to use
If you have multiple Azure Subscriptions you need to select the subscription to use.

Use this command to liste the available subscriptions for the account: 

```
azure account list
```

Set the subscription you would like to use as your `default` account for all instances of the Azure CLI instance. 
```
azure account set "Azure Pass" 
```

###Set the Azure Resource Manager mode
The Azure Resource Manager mode is not enabled by default, use the following command to enable Azure CLI Resource Manager commands.

```
azure config mode arm
```

###Create a Resource Group
```
azure group create -n CB_RESOURCE_GROUP -l "West US"
```
###Create a deployment and wait for success

```
azure group deployment create \
	--template-uri https://raw.githubusercontent.com/martinesmann/couchbase-azure/master/src/templates/azuredeploy.json \
    -e templates/azuredeploy.parameters.json \
    CB_RESOURCE_GROUP \
    AZURE_DEPLOYMENT
```
###Public IP for Resource Group
```
azure network public-ip list $AZURE_RESOURCE_GROUP_NAME
```