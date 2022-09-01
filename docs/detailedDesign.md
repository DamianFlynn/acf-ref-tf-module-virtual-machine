# [Solution] Detailed Design

## Consistent Design Overview

Innofactor offers a complete framework called the **Innofactor Azure Cloud Framework** for the governed, secured, and managed deployment of workloads and data in Microsoft Azure.

The framework places governance, security, management functions and workloads in subscriptions that are organised using Azure management groups for the purposes of role-based access control (RBAC) and policy inheritance. The complete management group and subscription architecture is illustrated below.

![The management groups & subscription design of the Innofactor Azure Cloud Framework](.attachments/azure-hierachy-structure.png)

The above management group design places all elements of the Innofactor Azure Cloud Framework into a single, top-level management group, isolating it from other Azure deployments from a governance perspective.

## Workload Design

::: caution
TODO: Define the workload

- What is it
- What is deployed
- where will it be deployed
- what properties should be provided
:::

The component will be deployed into the `p-gov` subscription, which is a child of the `Governance` management group hierachy.

The component will be deployed into a resource group called `p-gov-log` in the Azure region selected for the Innofactor Azure Cloud Foundation:


### Resource Group: `p-gov-log`

::: caution
TODO: Define the workload payload

- What is it
- What is deployed
- where will it be deployed
- what properties should be provided
:::

The following properties are applied to the resource group

- Locks:
  - Delete
    - Name: **resourceGroupDoNotDelete**

#### Resources

The following resources are deployed, configured with the properties as defined here

- Storage Account: `pgovlogaudit\<randomstring\>`
  - Performance: **Standard**
  - Replication: **Geo-redundant storage (GRS)**
  - Account Kind: **StorageV2**
  - Locks:
    - Delete
      - Name: **storageDoNotDelete**
  - Lifecycle Management Rules:
    - TieringRule
      - Blob Type:
        - **Block Blobs**
        - **Base Blobs**
        - **Snapshots**
      - Base Blobs:
        - Move to Cool Storage: **Base blobs haven't been modified in 14 days**
        - Move to Archive Storage: **Base blobs haven't been modified in 32 days**
        - Delete the blob: **Base blobs haven't been modified in X days**
      - Snapshots:
        - Delete the blob snapshot: **Snapshots created more than 32 days ago**
  - Blob Service:
    - Containers: **insights-activity-logs**
      - Access Policy: **Immutable Blob Storage**
        - Policy Type: **Time-Based Retention**
        - Set retention period for: **X + 1 days**
        - Allow Protected Append Writes To: **None**

## Governance

All features of governance relevant to the design are described here.

### Cost Management

| WAF Pillar        | WAF Principle                                     |
| ----------------- | ------------------------------------------------- |
| Cost Optimisation | Set up budgets and maintain cost controls         |
| Cost Optimisation | Continuously monitor and optimise cost management |

::: caution
TODO: Discuss cost management, for example budgets and cost management alerts, and define the settings which the customer would require in thier framework
:::

The cost of this component will be extremely low. The overhead of creating and maintaining cost-management monitoring and alerting will not be justified.

## Management

This is the operational management section.

### Resource Monitoring

| WAF Pillar             | WAF Principle                                                          |
| ---------------------- | ---------------------------------------------------------------------- |
| Operational Excellence | Understand operational health                                          |
| Performance Efficiency | Continuously monitor the application and the supporting infrastructure |

::: caution
TODO: Describe the logs and metrics collections, which will be implemented to validate the state and health of the services
:::

This section is not relevant to this component.

### Application Monitoring

| WAF Pillar             | WAF Principle                                                          |
| ---------------------- | ---------------------------------------------------------------------- |
| Reliability            | Observe application health                                             |
| Operational Excellence | Understand operational health                                          |
| Performance Efficiency | Continuously monitor the application and the supporting infrastructure |

::: caution
TODO: Where applicable, add Application Insights monitoring is added here.
:::

This section is not relevant to this component.

### Network Monitoring

| WAF Pillar             | WAF Principle                                                          |
| ---------------------- | ---------------------------------------------------------------------- |
| Operational Excellence | Understand operational health                                          |
| Performance Efficiency | Continuously monitor the application and the supporting infrastructure |

::: caution
TODO: Where applicable, add Azure Monitor connection monitoring is added here.
:::

This section is not relevant to this component.

### Alerting

| WAF Pillar             | WAF Principle                                                          |
| ---------------------- | ---------------------------------------------------------------------- |
| Operational Excellence | Understand operational health                                          |
| Performance Efficiency | Continuously monitor the application and the supporting infrastructure |

::: caution
TODO: Design the alerts here. Identify the targets for example distribution groups, webhooks, etc.
:::

This section is not relevant to this component.

### Action Groups

| WAF Pillar             | WAF Principle                                                          |
| ---------------------- | ---------------------------------------------------------------------- |
| Operational Excellence | Understand operational health                                          |
| Performance Efficiency | Continuously monitor the application and the supporting infrastructure |

::: caution
TODO: Design the action groups here.
:::

This section is not relevant to this component.

### Operations

| WAF Pillar                         | WAF Principle                                   |
| ---------------------------------- | ----------------------------------------------- |
| Operational Excellence             | Embrace continuous operational improvement      |
| Identify improvement opportunities | Performance Efficiency with resolution planning |

::: caution
TODO: How can you use issues to improve the workload?
:::

This section is not relevant to this component.

### Update Management

::: caution
TODO: How are updates deployed, if this is a virtual machine deployment?

- Consider rolling updates
- Patching windows
:::

This section is not relevant to this component.

## Security

The security of the design is described in this section.

### Identity & Access Management

| WAF Pillar | WAF Principle                    |
| ---------- | -------------------------------- |
| Security   | Automate and use least privilege |

::: caution
TODO: Any users, service principals, and so on are described here.
:::

Access to the data is limited to:

- Those with access to the `tenant root` management group
  - Outside the control of **Innofactor**
- Members of the access groups for the `VDC Root` management group
  - `AZ RBAC mg VDC Root Owner`
  - `AZ RBAC mg VDC Root Contributor`
  - `AZ RBAC mg VDC Root Reader`
- Members of the access groups for the `Governance` management group
  - `AZ RBAC mg Governance Owner`
  - `AZ RBAC mg Governance Contributor`
  - `AZ RBAC mg Governance Reader`
- Members of the access groups for the `p-gov` subscription
  - `AZ RBAC sub p-gov Owner`
  - `AZ RBAC sub p-gov Contributor`
  - `AZ RBAC sub p-gov Reader`

Governance operators and investigators requiring access to only this log data should be granted membership of `AZ RBAC sub p-gov Reader` Azure AD group, limiting them to:

- The `p-gov` subscription so they cannot see other components or workloads.
- **Read only** permissions so they cannot alter any resources or configurations.

### Network Security

| WAF Pillar | WAF Principle                         |
| ---------- | ------------------------------------- |
| Security   | Plan resources and how to harden them |
| Security   | Identify and protect endpoints        |

::: caution
TODO: If there is a network, the security of the network is described here.
:::

This section is not relevant to this component.

### Resource Security

| WAF Pillar | WAF Principle                         |
| ---------- | ------------------------------------- |
| Security   | Plan resources and how to harden them |

::: caution
TODO: Any security features in resources that are configured are described here.

- This may be features of Azure SQL or Defender for Endpoints in VMs.
:::

The resource group and storage account will have **delete locks** placed on them.

### Secret Storage

| WAF Pillar | WAF Principle                         |
| ---------- | ------------------------------------- |
| Security   | Plan resources and how to harden them |

::: caution
TODO: Describe how any secrets for the solution are stored and accessed.
:::

This section is not relevant to this component.

### Security Monitoring

| WAF Pillar | WAF Principle                                   |
| ---------- | ----------------------------------------------- |
| Security   | Monitor system security, plan incident response |

::: caution
TODO: Configuration and resources such as Azure Defender for Cloud and any Sentinel customisations are added here.

- Define the email addresses of the distibution lists, which should be notified
:::

Microsoft Defender for Cloud will be enabled:

- Resource Types:
  - **Storage**
  - **Resource Manager**
- Email Recipients:
  - All Users With The Following Roles: **Owner**, **Contributor**
  - Additional Email Addresses: ***To Be Decided***
- Notify About Alerts With The Following Severity Levels (Or Higher): **Medium**
- Integrations:
  - Allow Microsoft Defender for Cloud Apps to access my data: **Enabled**
  - Allow Microsoft Defender for Endpoint to access my data: **Enabled**
- Security Policy:
  - Industry Standards: **ISO 27001:2013**

### Application Security

::: caution
TODO: Define how are you implementing security at the application layer, if relevant?
:::

This section is not relevant to this component.

### Data Security

| WAF Pillar | WAF Principle             |
| ---------- | ------------------------- |
| Security   | Classify and encrypt data |

::: caution
TODO: Does data need to be classified and encrypted? If so, do it here.
:::

The data in this component is subject to the security requirements of the GDPR. The data in the storage account will be encrypted at rest by default.

### Risk Analysis

| WAF Pillar | WAF Principle                            |
| ---------- | ---------------------------------------- |
| Security   | Model and test against potential threats |

::: caution
TODO: Understand the risks and threats.

- Describe them.
- Discuss possible mitigations here.
- Describe security decisions that are made.
:::

This section is not relevant to this component.

## Compliance

The data in this component is subject to the security requirements of
the GDPR.

- The data in the storage account will be encrypted at rest by default.
- Data will be retained in this component only for auditing.
- The data will be kept only for as long as the organisation requires to keep audit data.
- Audit data will automatically be deleted 1 day after the retention period ends.

## Backup & Disaster Recovery

### Backup

| WAF Pillar             | WAF Principle                          |
| ---------------------- | -------------------------------------- |
| Operational Excellence | Rehearse recovery and practice failure |

::: caution
TODO: What are the backup policies?

- How are backups tested?
- How are backups restored?
- At what cadance should the Backup validation occur
- How is the validation process audited?
:::

This section is not relevant to this component.

### Disaster Recovery

| WAF Pillar             | WAF Principle                          |
| ---------------------- | -------------------------------------- |
| Operational Excellence | Rehearse recovery and practice failure |

::: caution
TODO: Are there any DR features?

- How are DR features tested?
- How is the DR plan invoked and implemented?
- At what cadance should the DR validation occur
- How is the DR process audited?
:::

The data in this component will have 6 redundant replicas:

- Three synchronous replicas in the primary Azure region.
- Three asynchronous replicas in the paired Azure region.

## Application Layer

| WAF Pillar             | WAF Principle                                       |
| ---------------------- | --------------------------------------------------- |
| Security               | Protect against code-level vulnerabilities          |
| Performance Efficiency | Run performance testing in the scope of development |

::: caution
TODO:  Where applicable, describe the workload design at the application layer.

Examples

- ADDS design for Azure VM domain controllers.
- Integrations from/to other workloads should be described here.
:::

This section is not relevant to this component.

# Well Architected Framework Checklist

Each pillar of the Well-Architected Framework has one or more checklists or considerations. Each should be reviewed --

::: note
Not all checklists within the Well Architected Framework may be relevant for the component service.
:::

## Reliability Checklist

::: caution
TODO: Complete the checklist

Principles should have a completed status of:

- **Yes**: Meets recommendations
- **No**: Does not meet recommendations
- **N/A**: Not applicable

Use the notes column to add any comments, such as how the item was set to Yes or why it was set to No.
:::

[Resiliency Principles](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/principles)

| WAF Principle                   | Notes | Completed? |
| ------------------------------- | ----- | ---------- |
| Design for business-defined SLA |       | N/A        |
| Observe application health      |       | Verify?    |
| Design for self-healing         |       | Verify?    |
| Design for Failure              |       | Verify?    |
| Drive automation                |       | Verify?    |
| Design for scale-out            |       | Verify?    |

## Security Checklist

::: caution
TODO: Complete the checklist

Principles should have a completed status of:

- **Yes**: Meets recommendations
- **No**: Does not meet recommendations
- **N/A**: Not applicable

Use the notes column to add any comments, such as how the item was set to Yes or why it was set to No.
:::

[Security Principles](https://docs.microsoft.com/en-us/azure/architecture/framework/security/security-principles)

| WAF Principle                                   | Notes | Completed? |
| ----------------------------------------------- | ----- | ---------- |
| Plan resources and how to harden them           |       | Verify?    |
| Automate and use least privilege                |       | Verify?    |
| Classify and encrypt data                       |       | Verify?    |
| Monitor system security, plan incident response |       | Verify?    |
| Identify and protect endpoints                  |       | Verify?    |
| Protect against code-level vulnerabilities      |       | Verify?    |
| Model and test against potential threats        |       | Verify?    |

## Cost Optimisation

::: caution
TODO: Complete the checklist

Principles should have a completed status of:

- **Yes**: Meets recommendations
- **No**: Does not meet recommendations
- **N/A**: Not applicable

Use the notes column to add any comments, such as how the item was set to Yes or why it was set to No.
:::

[Cost Principles](https://docs.microsoft.com/en-us/azure/architecture/framework/cost/principles)

| WAF Principle                                     | Notes | Completed? |
| ------------------------------------------------- | ----- | ---------- |
| Choose the correct resources                      |       | Verify?    |
| Set up budgets and maintain cost controls         |       | Verify?    |
| Dynamically allocate and de-allocate resources    |       | Verify?    |
| Optimise workloads, aim for scalable costs        |       | Verify?    |
| Continuously monitor and optimise cost management |       | Verify?    |

## Operational Excellence

::: caution
TODO: Complete the checklist

Principles should have a completed status of:

- **Yes**: Meets recommendations
- **No**: Does not meet recommendations
- **N/A**: Not applicable

Use the notes column to add any comments, such as how the item was set to Yes or why it was set to No.
:::

[Operational Principles](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/principles)

| WAF Principle                              | Notes | Completed? |
| ------------------------------------------ | ----- | ---------- |
| Optimise build and release processes       |       | Verify?    |
| Understand operational health              |       | Verify?    |
| Rehearse recovery and practice failure     |       | Verify?    |
| Embrace continuous operational improvement |       | Verify?    |
| Use loosely coupled architecture           |       | Verify?    |

## Performance Efficiency

::: caution
TODO: Complete the checklist

Principles should have a completed status of:

- **Yes**: Meets recommendations
- **No**: Does not meet recommendations
- **N/A**: Not applicable

Use the notes column to add any comments, such as how the item was set to Yes or why it was set to No.
:::

[Scalability Principles](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/principles)

| WAF Principle                                                          | Notes | Completed? |
| ---------------------------------------------------------------------- | ----- | ---------- |
| Understand the challenges of distributed architectures                 |       | Verify?    |
| Continuously monitor the application and the supporting infrastructure |       | Verify?    |
| Identify improvement opportunities with resolution planning            |       | Verify?    |
| Invest in capacity planning                                            |       | Verify?    |
