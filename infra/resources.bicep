param suffix string
param location string

module appInsights 'modules/appInsights.bicep' = {
  name: 'deploy-${suffix}-app-insights'

  params: {
    location: location
    suffix: suffix
  }
}

module cosmosDb 'modules/cosmosDb.bicep' = {
  name: 'deploy-${suffix}-cosmos-db'

  params: {
    location: location
    suffix: suffix
  }
}

module appService 'modules/appService.bicep' = {
  name: 'deploy-${suffix}-app-service'

  params: {
    location: location
    suffix: suffix
    instrumentationKey: appInsights.outputs.instrumentationKey
    cosmosDbAccountName: cosmosDb.outputs.accountName
  }
}
