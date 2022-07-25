param suffix string
param location string
param instrumentationKey string
param cosmosDbAccountName string

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-${suffix}'
  location: location

  kind: 'Linux'
  sku: {
    name: 'B1'
  }
}

resource api 'Microsoft.Web/sites@2022-03-01' = {
  name: 'web-${suffix}'
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: instrumentationKey
        }
      ]
    }
  }
}

var cosmosAccountReaderRoleId = resourceId('Microsoft.Authorization/roleDefinitions', 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8')

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: cosmosDbAccountName
}

resource apiRoleCosmosDb 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(cosmosAccountReaderRoleId, api.id, cosmosAccount.id)
  scope: cosmosAccount

  properties: {
    roleDefinitionId: cosmosAccountReaderRoleId
    principalId: api.identity.principalId
  }
}
