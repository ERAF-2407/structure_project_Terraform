# GEMINI.md - Project Context

## Project Overview
This project manages AWS infrastructure using **Terraform**. It follows a modular architecture and separates configurations into different environments (e.g., development and production).

### Main Technologies
- **Terraform**: Infrastructure as Code (IaC) tool (required version >= 1.5.0).
- **AWS**: Cloud provider (provider version ~> 5.0).
- **Ubuntu 22.04**: OS used for EC2 instances.
- **Node.js**: Automatically installed on compute instances via `user_data`.
- **MySQL (RDS)**: Database engine used in the database module.

### Architecture
The project is structured to promote reusability and environment isolation:
- **`environments/`**: Contains environment-specific configurations (`dev`, `prod`). Each environment has its own state and variable values.
- **`modules/`**: Contains reusable infrastructure components:
  - **`compute/`**: Provisions EC2 instances with specific security groups and Node.js setup.
  - **`database/`**: Provisions RDS instances (MySQL) with security groups restricted to the compute instances.
  - **`networking/`**: (In development) Intended for VPC and network management.
  - **`storage/`**: Provisions an S3 bucket configured for static website hosting, with public access enabled and appropriate bucket policies.

---

## Building and Running

### Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) installed.
- AWS CLI configured with appropriate credentials or profile.
- SSH public key available at `~/.ssh/aws_ec2_node.pub` (used by the compute module).

### Key Commands
Commands should be executed within the specific environment directory (e.g., `environments/dev/`).

- **Initialize Project:**
  ```bash
  terraform init
  ```
- **Plan Infrastructure:**
  ```bash
  terraform plan
  ```
- **Apply Changes:**
  ```bash
  terraform apply
  ```
- **Destroy Infrastructure:**
  ```bash
  terraform destroy
  ```

### Variables
Sensitive variables like `db_password_dev` should be provided via a `.tfvars` file (not committed), environment variables, or interactive input.

---

## Development Conventions

### Coding Style
- **Modules first**: Logic should reside in the `modules/` directory to ensure it can be reused across environments.
- **Dynamic Data**: Use `data` blocks (e.g., `aws_ami`, `aws_vpc`) to fetch resource IDs dynamically instead of hardcoding them.
- **Security**: 
  - Restrict Security Group ingress rules as much as possible.
  - Use `sensitive = true` for password variables.
  - Avoid committing `.tfstate` files or `terraform.tfvars` containing secrets.

### Testing Practices
- Always run `terraform plan` before `apply` to verify the impact of changes.
- Use `terraform validate` to check for syntax and internal consistency.
- Environment isolation ensures that changes in `dev` do not affect `prod`.

### Contribution Guidelines
1. Define new resources within a module if they are expected to be reused.
2. Update the environment's `main.tf` to call the new or updated module.
3. Ensure variables are documented with a `description`.
