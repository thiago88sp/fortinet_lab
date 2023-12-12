# Creating Fortigate VM with IpSec VPN

![image](https://github.com/thiago88sp/fortinet_lab/assets/54182968/fa4a07c7-89f7-4801-aa0e-97f9afa9cc4c)

## Requirements

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.38.0
* Terraform Provider Template >= 2.2.2
* Terraform Provider Random >= 3.0.0
* Terraform Provider FortiOS >=1.18.1

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
