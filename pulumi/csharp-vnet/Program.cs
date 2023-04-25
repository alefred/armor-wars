using Pulumi;
using Pulumi.AzureNative.Resources;
using AzureNative = Pulumi.AzureNative;
using System.Collections.Generic;

return await Pulumi.Deployment.RunAsync(() =>
{
    // Naming Variables
    string rg_name = "rg-pulumi-csharp-01";
    string vnet_name = "vnet-spoke-pulumi-01";
    // Create an Azure Resource Group
    var resourceGroup = new ResourceGroup(rg_name);

    var virtualNetwork = new AzureNative.Network.VirtualNetwork("virtualNetwork", new()
    {
        AddressSpace = new AzureNative.Network.Inputs.AddressSpaceArgs
        {
            AddressPrefixes = new[]
            {
                "10.0.0.0/16",
            },
        },
        Location = "eastus2",
        ResourceGroupName = resourceGroup.Name,
        VirtualNetworkName = vnet_name,
    });
});