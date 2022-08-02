// ---------
// Resources
// ---------

// Log Analytics
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: ''
  location: 'global'
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

// App Insights
resource component 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: ''
  location: 'global'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
}

// ---------
// Variables
// ---------

// ----------
// Parameters
// ----------
