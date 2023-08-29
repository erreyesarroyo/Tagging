<#This Azure Function is used to tag new resource groups with the user name of the creator and date created.
  -Event Grid send a trigger to the Azure Function when a resource group is added to a subscription.  
  -Advanced filters in Event Grid limit the alter to a defined data type.  
  -Resource types are specified in the input data from Event Grid.  
  -Azure function applies the tag and tag value to the resource group.

# Parameter Name must match bindings
param($eventGridEvent, $TriggerMetadata)

# Get the day in Month Day Year format
$date = Get-Date -Format "MM/dd/yyyy"
# Add tag and value to the resource group
$nameValue = $eventGridEvent.data.claims.name
$tags = @{"Creator"="$nameValue";"DateCreated"="$date"}


write-output "Tags:"
write-output $tags

# Resource Group Information:

$rgURI = $eventGridEvent.data.resourceUri
write-output "rgURI:"
write-output $rgURI

# Update the tag value

Try {
    Update-AzTag -ResourceId $rgURI -Tag $tags -operation Merge -ErrorAction Stop
}
Catch {
    $ErrorMessage = $_.Exception.message
    write-host ('Error assigning tags ' + $ErrorMessage)
    Break
}
