// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

// Resource Groups
resource globalResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: global.resourceGroup.name
  location: global.resourceGroup.location
}
resource regionalResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: regional.resourceGroup.name
  location: regional.resourceGroup.location
  dependsOn: [ globalResourceGroup ]
}

// -------
// Modules
// -------

module globalResources 'modules/api/resources.global.bicep' = {
  name: 'Microsoft.Resources.Global'
  scope: globalResourceGroup
  params: {
    global: global
    tags: tags
  }
}
module regionalResources 'modules/api/resources.regional.bicep' = [for region in regional.resources: if (region.enabled == true) {
  name: 'Microsoft.Resources.Regional.${defaults.locations[region.location]}'
  scope: regionalResourceGroup
  params: {
    global: global
    region: region
    tags: tags
  }
  dependsOn: [ globalResources ]
}]

// ---------
// Variables
// ---------

var global = config.global
var regional = config.regional

var config = loadJsonContent('./azureconfig.json')
var defaults = loadJsonContent('./azuredefaults.json')

var tags = {
  created: '01/08/22'
  modified: date
}

// ----------
// Parameters
// ----------

param date string = utcNow('dd/MM/yy')
