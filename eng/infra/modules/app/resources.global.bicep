// ---------
// Resources
// ---------

// Storage Account
resource account 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: global.resources.name
  location: global.resources.location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
  resource blob 'blobServices' = {
    name: 'default'
    resource container 'containers' = {
      name: '$web'
      properties: {
        publicAccess: 'Blob'
      }
    }
  }
}

// FrontDoor
resource profile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: global.resources.name
  location: 'global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    originResponseTimeoutSeconds: 60
  }
  resource endpoint 'afdEndpoints' = {
    name: global.resources.name
    location: 'global'
    properties: {
      enabledState: 'Enabled'
    }
    resource route 'routes' = {
      name: 'default'
      properties: {
        enabledState: 'Enabled'
        linkToDefaultDomain: 'Enabled'
        forwardingProtocol: 'HttpsOnly'
        httpsRedirect: 'Enabled'
        supportedProtocols: [
          'Https'
        ]
        cacheConfiguration: {
          queryStringCachingBehavior: 'IgnoreQueryString'
        }
        originGroup: {
          id: profile::group.id
        }
      }
    }
  }
  resource group 'originGroups' = {
    name: 'default'
    properties: {
      loadBalancingSettings: {
        sampleSize: 4
        successfulSamplesRequired: 3
        additionalLatencyInMilliseconds: 50
      }
      healthProbeSettings: {
        probePath: '/'
        probeRequestType: 'HEAD'
        probeProtocol: 'Https'
        probeIntervalInSeconds: 100
      }
      sessionAffinityState: 'Disabled'
    }
    resource origin 'origins' = {
      name: 'default'
      properties: {
        enabledState: 'Enabled'
        hostName: '${global.resources.name}.blob.core.windows.net'
        priority: 1
        weight: 1000
        enforceCertificateNameCheck: true
      }
    }
  }
}

// ----------
// Parameters
// ----------

param global object
