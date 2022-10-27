param roleName string 
param roleActions array 
param roleDesc string

param userIdentityName string 
param location string 
param tags object


resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(roleName, string(roleActions))
  properties: {
    assignableScopes: [
      subscription().id
    ]
    description: roleDesc
    permissions: [
      {
        actions: roleActions
        dataActions: []
        notActions: []
        notDataActions: []
      }
    ]
    roleName: roleName
    type: 'customRole'
  }
}

// Get a role ID with az cli
// ref: https://github.com/Azure/bicep/issues/1895
// az role definition list -o json \
//  --query "[?roleType=='BuiltInRole'].{roleName: roleName, name: name}" | \
//  jq -nr '[inputs|.[] | .roleName |= (gsub("[(].*[)]"; ""; "i") \
//    | gsub("[./-]"; " ") | gsub("(?<x>[A-z])(?<y>[A-z]+)"; "\(.x|ascii_upcase)\(.y)") \
//    | gsub(" "; "")) |select(.roleName == "Contributor").name][0]'


resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userIdentityName
  location: location 
  tags: tags
}

resource assignRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(userAssignedIdentity.name)
  properties: {
    principalId: userAssignedIdentity.properties.principalId
    roleDefinitionId: customRole.id
  }
}
