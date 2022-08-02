// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource globalApiGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: globalGroupName
  location: config.global.location
}

resource regionalApiGroups 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: regionalGroupName
  location: config.global.location
  dependsOn: [ globalApiGroup ]
}

// -------
// Modules
// -------

module globalApiResources 'modules/api/global.bicep' = {
  name: 'Microsoft.Resources.Global'
  scope: resourceGroup(globalApiGroup.name)
  params: {
    global: config.global
    tags: tags
  }
}

module regionalApiResources 'modules/api/regional.bicep' = [for region in config.regions: if (region.enabled == true) {
  name: 'Microsoft.Resources.Regional.${region.country}'
  scope: resourceGroup(regionalApiGroups.name)
  params: {
    global: config.global
    region: region
    tags: tags
  }
  dependsOn: [ globalApiResources ]
}]

// ---------
// Variables
// ---------

var config = loadJsonContent('../config//data.json')

var globalGroupName = 'Latency-Global'
var regionalGroupName = 'Latency-Regional'

var tags = {
  created: '01/08/22'
  modified: date
}

// ----------
// Parameters
// ----------

param date string = utcNow('dd/MM/yy')
