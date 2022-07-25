param suffix string
param location string

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: 'cdb-${suffix}'
  location: location

  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false

    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }

    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  name: 'db-${suffix}'
  parent: account

  properties: {
    resource: {
      id: 'db-${suffix}'
    }
  }
}

resource deparmentsContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: 'departments'
  parent: database

  properties: {
    resource: {
      partitionKey: {
        paths: [ '/id' ]
      }
      id: 'departments'
    }
  }
}

resource cheesesContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: 'cheeses'
  parent: database

  properties: {
    resource: {
      partitionKey: {
        paths: [ '/id' ]
      }
      id: 'cheeses'
    }
  }
}

output accountName string = account.name
