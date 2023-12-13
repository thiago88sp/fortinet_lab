# Creating Fortigate VM with IpSec VPN

![image](https://github.com/thiago88sp/fortinet_lab/assets/54182968/fa4a07c7-89f7-4801-aa0e-97f9afa9cc4c)

## Requirements

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.38.0
* Terraform Provider Template >= 2.2.2
* Terraform Provider Random >= 3.0.0
* Terraform Provider FortiOS >=1.18.1

## Deployment overview

Terraform deploys the following components:

* Virtual Networks: Separate networks are created for each region (fgtvnetwork-a and fgtvnetwork-b).
* Subnets: Each network has public and private subnets (publicSubnet-a, privatesubnet-a, and similar for West US).
* Public IPs: Public IPs are assigned to FortiGate VMs for inbound connections (FGTPublicIp-a and FGTPublicIp-b).
* NSGs: Network Security Groups control inbound and outbound traffic (publicnetworknsg-a, privatenetworknsg-a, and similar for West US). Outgoing rules are also defined.
* FortiGate VMs: FortiOS VMs are deployed in each region (fgtvm-a and fgtvm-b). They can use custom images or marketplace images.
    * VPN Configuration:
        - Phase 1: Defines the tunnel parameters like authentication, encryption, and lifetime.
        - Phase 2: Defines the traffic selectors and security settings for the VPN tunnel.
        - Firewall Policies: Allow traffic between the two networks based on source and destination addresses.
        - Static Routes: Add routes for the remote network subnets on each FortiGate VM.
* Azure Bastion (One in each region, but it is possible to use a single Bastion in one of the regions to communicate with the VMs in the private subnet.)
* Two Linux Ubuntu VMs (one in each region for VPN communication testing)

## Deployment

To deploy the FortiGate-VM to Azure:

1. Clone the repository.

   ```sh
   git clone https://github.com/thiago88sp/fortinet_lab.git
    ```
    
2. Customize variables in the `terraform.tfvars.example` and `variables.tf` file as needed.  And rename `terraform.tfvars.example` to `terraform.tfvars`.
3. Initialize the providers and modules:

   ```sh
   cd XXXXX
   terraform init
    ```


## To connect with me on Linkedin
[<img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" />](https://www.linkedin.com/in/thiagosouzapontes/)
