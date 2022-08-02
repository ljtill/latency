// ---------
// Resources
// ---------

// Log Analytics
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }
  tags: tags
}

// App Insights
resource component 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
  tags: tags
}

// ---------
// Variables
// ---------

var name = global.name
var location = global.location

// ----------
// Parameters
// ----------

param global object
param tags object
