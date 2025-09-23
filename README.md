# Azure Load Testing - concurrent users on Azure Kubernetes Service (AKS)

This repository provides a comprehensive guide on how to set up and run load tests using Azure Load Testing with an
application deployed on Azure Kubernetes Service (AKS). The guide includes steps for creating the necessary Azure
resources, deploying a sample application, and configuring load tests to simulate concurrent users.

## Prerequisites

- An active Azure subscription. If you don't have one, you can create
  a [free account](https://azure.microsoft.com/free/).
- Azure CLI or Azure Powershell installed. You can download it
  from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or use scripts
  in [scripts](./scripts/README.md) folder.
- kubectl installed. You can follow the installation
  guide [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

## Steps to Set Up and Run Load Tests

1. Login to your Azure account using Azure CLI or Azure Powershell:
   ```bash
   az login
   ```

   ```powershell
   Login-AzAccount
   ``` 

2. Create Azure Resources by running scripts in the `scripts` folder:
    - run bicep files

3. Compile the code and deploy the application to AKS:
    - Navigate to the `ALT` folder and follow the instructions in the `README.md` file to compile and deploy the
      sample application to your AKS cluster.
    - Make sure to note the external IP address of the service once deployed, as you will need it for the load testing
      configuration.

4. Configure Azure Load Testing:
    - Navigate to the Azure portal and go to the Load Testing resource created in the previous step.
    - Create a new load test and configure the test parameters, including the number of concurrent users, test duration,
      and the target URL of the application deployed on AKS.
    - Upload your test script if you have one, or use the built-in options to define the load test.
    - Start the load test and monitor the results in real-time with Azure Load Testing's dashboard and Application
      Insights.

5. Analyze Results:
    - After the test completes, analyze the results to understand how your application performed under load.
    - Look for metrics such as response times, error rates, and throughput to identify any bottlenecks or areas for
      improvement.

## Cleanup

To avoid incurring unnecessary costs, make sure to delete the Azure resources created for this load testing exercise
once you are done.

```bash
az group delete --name <your-resource-group-name> --yes --no-wait
``` 

# Additional information

For more detailed instructions and additional configurations, refer to the official documentation
for [Azure Load Testing](https://learn.microsoft.com/en-us/azure/load-testing/)
and [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/).