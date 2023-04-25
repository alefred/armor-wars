using Pulumi;
using Pulumi.AzureNative.Resources;
using AzureNative = Pulumi.AzureNative;
using System.Collections.Generic;

return await Pulumi.Deployment.RunAsync(() =>
{
    // Naming Variables
    string rg_name = "rg_pulumi_csharp";
    string vnet_name = "vnet_spoke_pulumi";
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