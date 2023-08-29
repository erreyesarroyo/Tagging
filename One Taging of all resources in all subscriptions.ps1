# Tagging
Tag all resources at once. Can be scoped at tenant, subscription, and rg level. 



# Se the right environment and log in to azure CLI
az cloud set -n azureusgovernment
az login

# Get all subscriptions
$subscriptions = az account list --output json | ConvertFrom-Json

foreach ($subscription in $subscriptions) {
    # Set the subscription to the current one in the loop
    az account set --subscription $subscription.id

    # List all resources in the current subscription
    $resources = az resource list --query "[].{id:id}" --output json | ConvertFrom-Json

    foreach ($resource in $resources) {
        # Add the tag Banana=True to each resource.
        # The --tags command with `merge` will keep existing tags and add/override the Banana tag.
        az resource tag --tags Banana=True --id $resource.id --mode merge
    }
}

Log out from Azure CLI for security reasons
az logout
