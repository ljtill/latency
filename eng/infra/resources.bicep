// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource globalGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'Latency-Global'
  location: config.global.location
}

resource regionalGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = [for region in config.regions: {
  name: 'Latency-Regional-${'Latency-Regional-${region.country}'}'
  location: region.location
}]

// -------
// Modules
// -------

module globalResource 'modules/api/global.bicep' = {
  name: 'Microsoft.Resources.Global'
  scope: resourceGroup(globalGroup.name)
  params: {}
}

module regionalResource 'modules/api/regional.bicep' = [for region in config.regions: {
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
