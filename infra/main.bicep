targetScope = 'subscription'

@description('Specifies the Azure region to use.')
param location string

@description('Specifies the targetted environment.')
@allowed([ 'dev', 'prod' ])
param env string

var suffix = '${env}-api-health-demo-${uniqueString(subscription().id, location)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${suffix}'
  location: location
}

module resources 'resources.bicep' = {
  name: 'deploy-${suffix}'
  scope: rg

  params: {
    location: location
    suffix: suffix
  }
}
