targetScope = 'subscription'

@description('Monthly budget in the billing currency of the subscription.')
param budgetAmount int = 10

@description('First day of the month the budget starts, as YYYY-MM-DD.')
param budgetStartDate string = '2026-11-01'

// Passed at deploy time so the address stays out of this public repo.
@description('Email address that receives the budget alerts.')
param alertEmail string

param location string = 'germanywestcentral'
param resourceGroupName string = 'rg-pryvit'

@description('Full image name of the API. Leave empty until the first image is in the registry.')
param apiImage string = ''

resource appGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module app 'app.bicep' = {
  name: 'pryvit-app'
  scope: appGroup
  params: {
    location: location
    apiImage: apiImage
  }
}

output registryName string = app.outputs.registryName
output registryServer string = app.outputs.registryServer
output apiHost string = app.outputs.apiHost

resource budget 'Microsoft.Consumption/budgets@2026-06-01' = {
  name: 'pryvit-monthly'
  properties: {
    category: 'Cost'
    amount: budgetAmount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: budgetStartDate
    }
    notifications: {
      actual50: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 50
        thresholdType: 'Actual'
        contactEmails: [alertEmail]
      }
      actual100: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Actual'
        contactEmails: [alertEmail]
      }
      forecast100: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Forecasted'
        contactEmails: [alertEmail]
      }
    }
  }
}
