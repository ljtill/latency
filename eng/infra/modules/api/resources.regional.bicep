// ---------
// Resources
// ---------

// Storage Account
resource account 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: region.name
  location: region.location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
  tags: tags
}

// Key Vault
resource vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: region.name
  location: region.location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: reference(function.id, '2021-03-01', 'Full').identity.principalId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
    enableSoftDelete: false
    enableRbacAuthorization: false
  }
  tags: tags
}

// App Service Plan
resource plan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: region.name
  location: region.location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
  tags: tags
}

// Function App
resource function 'Microsoft.Web/sites@2022-03-01' = {
  name: region.name
  location: region.location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: insight.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: insight.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${account.name};AccountKey=${listKeys(account.id, account.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${account.name};AccountKey=${listKeys(account.id, account.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: '${region.name}a8c6'
        }
      ]
      linuxFxVersion: 'Node|16'
    }
    serverFarmId: plan.id
    httpsOnly: true
  }
  tags: tags
}

// ---------
// Resources
// ---------

resource insight 'Microsoft.Insights/components@2020-02-02' existing = {
  name: global.resources.name
  scope: resourceGroup(global.resourceGroup.name)
}

// ----------
// Parameters
// ----------

param global object
param region object
param tags object
