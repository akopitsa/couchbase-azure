#Couchbase with Azure ARM Templates
This blog post describes how to set up your own Couchbase Cluster using Azure Resource Manager templates, aka ARM templates.

##Prerequisites: 
This post is describing how to host your own Couchbase Cluster in Microsoft Azure. If you would like to try this you will need a few things:

1. Azure Subscription, sign-up here for a [free trial](https://azure.microsoft.com/en-us/pricing/free-trial).
2. Azure CLI, installed on your system, [how to install](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/). 
3. [Github Account](https://github.com/), optional if you would like to experiment with your own ARM templates.

##What you will deploy
This blog post will walk you through the steps needed to deploy your own Couchbase 4.1 Cluster in Microsoft Azure. The size of the cluster is configurable but will as a minimum consist of a three node cluster set-up with replication to one node. You can also chose the data center location for Cluster between all available locations assessable with your Microsoft Azure subscription.   

In the process of deploying Couchbase to Azure you will learn about Azure Resource Manager Templates and how to edit them to fit your needs. This will allow you to change default values in the Couchbase ARM template but also understand how to use ARM templates in other cases when using Microsoft Azure.

##Azure Resource Manager templates
Azure Resource Manager allows you to provision applications to Microsoft Azure using a declarative template. With a single single template, you can deploy multiple services along with their dependencies. You also have the option to split up your ARM templates into multiple templates that each describe individual resources. You can use the same templates individually or separately to repeatedly deploy your application/resources during every stage of the application lifecycle.

You can compare ARM templates to other resource description technologies like [chef.io](https://docs.chef.io/resource_template.html) or others.

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

ARM templates are written in JSON with the option to use some special formatted strings that can work as references to variables and or method calls. 

The ARM template snippet below shows how to define a virtual network and the use of `variables` and `parameters` in an ARM template.

```
{
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[variables('virtualNetworkName')]",
      "location": "[variables('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]"
            }
          }
        ]
      }
    },
```

You can read more about how to author ARM templates from the Microsoft [Azure documentation](https://azure.microsoft.com/en-us/documentation/articles/resource-group-authoring-templates/). 

It also possible to execute external code like shell scripts etc. to allow for custom configuration, installation on Virtual Machine as part of the set-up process.

```
 "vmScripts": {
      "scriptsToDownload": [
        "[concat(variables('templateBaseUrl'), 'couchbase-azure-install.sh')]",
        "[concat(parameters('cbPackageDownloadBase'), parameters('cbPackage'))]",
        "[concat(variables('templateBaseUrl'), 'vm-disk-utils-0.1.sh')]"
      ],
      "installCommand": "[concat('bash couchbase-azure-install.sh -d ', parameters('cbPackage'), ' -n ', parameters('clusterName'), ' -i ', concat(variables('networkSettings').nodesIpPrefix, '-', variables('clusterSpec').clusterSize), ' -a ', variables('machineSettings').adminUsername, ' -p ', variables('machineSettings').adminPassword, ' -r ', variables('clusterSpec').couchbaseRamQuota)]",
      "setupCommand": "[concat('bash couchbase-azure-install.sh -d ', parameters('cbPackage'), ' -n ', parameters('clusterName'), ' -i ', concat(variables('networkSettings').nodesIpPrefix, '-', variables('clusterSpec').clusterSize), ' -a ', variables('machineSettings').adminUsername, ' -p ', variables('machineSettings').adminPassword, ' -r ', variables('clusterSpec').couchbaseRamQuota, ' -l')]"
    },
    "clusterSpec": "[variables(concat('tshirtSize', parameters('tshirtSize')))]"
``` 

In combination all this allows for a very fine grained configuration and set-up of resources in Azure. 
The above ARM template snippet is taken from the [Couchbase Cluster ARM template](https://github.com/martinesmann/couchbase-azure/tree/master/src/templates) on GitHub. 
  

##Azure CLI
The Azure CLI is a command line tool for working with Microsoft Azure build for Mac, Linux, and Windows. 

If you have a Windows background and prefer working with [PowerShell](https://azure.microsoft.com/en-us/documentation/articles/powershell-azure-resource-manager/) then most of the commands works there as well. 

I have chosen to use Azure CLI as it seems to have the wides audience and can be used on most platforms.



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
azure group create -n CB_RESOURCE_GROUP -l "Eest US"
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
azure network public-ip list CB_RESOURCE_GROUP
```