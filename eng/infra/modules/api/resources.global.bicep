// ---------
// Resources
// ---------

// Log Analytics
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: global.resources.name
  location: global.resources.location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
  tags: tags
}

// App Insights
resource component 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: global.resources.name
  location: global.resources.location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
  tags: tags
}

// ----------
// Parameters
// ----------

param global object
param tags object
