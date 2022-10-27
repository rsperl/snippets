param location string 
param userAssignedIdentity object 

resource myAction 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'my-action'
  location: location
  dependsOn: []
  kind: 'AzureCLI' 
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.39.0'
    retentionInterval: 'P1D'
    storageAccountSettings: {
      // storageAccountKey: storageAccount.listKeys().keys[0].value
      // storageAccountName: storageAccount.name
    }
    environmentVariables: [
    ]
    scriptContent: '''az webapp config set \
      --name $FN_APP_NAME \
      --subscription "$SUB_NAME" \
      --resource-group $RG_NAME \
      --always-on false && sleep 60
    '''
  }
}
