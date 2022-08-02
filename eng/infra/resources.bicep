// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource globalApiGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'Latency-Global'
  location: config.global.location
}

resource regionalApiGroups 'Microsoft.Resources/resourceGroups@2021-04-01' = [for region in config.regions: {
  name: 'Latency-Regional-${region.country}'
  location: region.location
}]

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

module regionalApiResources 'modules/api/regional.bicep' = [for region in config.regions: {
  name: 'Microsoft.Resources.Region.${region.country}'
  scope: resourceGroup('Latency-Regional-${region.country}')
  params: {
    global: config.global
    region: region
    tags: tags
  }
}]

// ---------
// Variables
// ---------

var config = loadJsonContent('../config//data.json')
var tags = {
  created: '01/08/22'
  modified: date
}

// ----------
// Parameters
// ----------

param date string = utcNow('dd/MM/yy')
