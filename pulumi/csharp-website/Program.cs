using Pulumi;
using Pulumi.AzureNative.Resources;
using AzureNative = Pulumi.AzureNative;
using Pulumi.AzureNative.Web;
using Pulumi.AzureNative.Web.Inputs;
using System.Collections.Generic;

return await Pulumi.Deployment.RunAsync(() =>
{
    var config = new Config();
    var admin_pass = config.Require("admin_pass");
    // Variables:
    string location          = "eastus2";
    string app_name          = "iacwars";
    string rg_name           = $"rg-{app_name}-pulumi-02";
    string webapp_name       = $"app-{app_name}-terraform-01";
    string service_plan_name = $"asp-{app_name}-terraform-01";
    string admin_login       = "adminla";
    string db_name           = $"db-{app_name}-pulumi-01";
    string db_server_name    = $"srv-{db_name}";
    // Create an Azure Resource Group
    var rg = new ResourceGroup(rg_name);

    // ** DATABASE DEFINITIONS ** //
    var base_dbserver = new AzureNative.DBforMySQL.Server(db_server_name, new()
    {
        Location = location,
        Properties = new AzureNative.DBforMySQL.Inputs.ServerPropertiesForDefaultCreateArgs
        {
            AdministratorLogin = admin_login,
            AdministratorLoginPassword = admin_pass,
            CreateMode = "Default"
        },
        ResourceGroupName = rg.Name,
        ServerName = db_server_name,
        Sku = new AzureNative.DBforMySQL.Inputs.SkuArgs
        {
            Capacity = 2,
            Family = "Gen5",
            Name = "GP_Gen5_2",
            Tier = "GeneralPurpose",
        },
    });
    // Export the primary key of the Storage Account
    // return new Dictionary<string, object?>
    // {
    //     ["fqdn"] = base_dbserver.FullyQualifiedDomainName
    // };

    var base_db = new AzureNative.DBforMySQL.Database("base_db", new()
    {
        Charset = "utf8",
        Collation = "utf8_general_ci",
        DatabaseName = db_name,
        ResourceGroupName = rg.Name,
        ServerName = base_dbserver.Name,
    });

    var base_rule = new AzureNative.DBforMySQL.FirewallRule("base_rule", new()
    {
        FirewallRuleName = "AllowAzureIPs",
        ResourceGroupName = rg.Name,
        ServerName = base_dbserver.Name,
        StartIpAddress = "0.0.0.0",
        EndIpAddress = "0.0.0.0",
    });

    // ** WEB APP DEFINITION ** //
    var base_sp = new AzureNative.Web.AppServicePlan("base_sp", new()
    {
        Kind = "app",
        Location = location,
        Name = service_plan_name,
        ResourceGroupName = rg.Name,
        Sku = new AzureNative.Web.Inputs.SkuDescriptionArgs
        {
            Tier = "Standard",
            Name = "S1",
        },
    });

    var appSettings = new InputList<NameValuePairArgs>
    {
        new NameValuePairArgs { Name = "ConnectionString", Value = $"Database={db_name};Data Source={base_dbserver.FullyQualifiedDomainName};User Id={admin_login}@{base_dbserver.Name};Password={admin_pass}" }
    };

    var base_webapp = new WebApp("base_webapp", new WebAppArgs
    {
        Name = webapp_name,
        ResourceGroupName = rg.Name,
        ServerFarmId = base_sp.Id,
        SiteConfig = new SiteConfigArgs
        {
            AppSettings = appSettings
        }
    });

});