# Terraform EC2 environments

The shared EC2 module is in `modules/ec2`. Each environment is an independent Terraform root configuration that calls it:

```text
modules/ec2/          # reusable EC2 module
environments/dev/     # dev root, tfvars, and S3 backend template
environments/prod/    # prod root, tfvars, and S3 backend template
```

Each environment uses S3 remote state without DynamoDB and has a distinct state key:

- `ec2/dev/terraform.tfstate`
- `ec2/prod/terraform.tfstate`

## Deploy an environment locally

From the repository root, substitute `dev` with `prod` as needed:

```powershell
Set-Location environments/dev
Copy-Item backend.hcl.example backend.hcl
# Edit backend.hcl and set the state bucket.
terraform init -reconfigure -backend-config=backend.hcl
terraform plan
terraform apply
```

The committed `dev.tfvars` and `prod.tfvars` files contain non-sensitive environment defaults. Backend settings are local-only and must not contain AWS access keys; use the standard AWS credential provider chain.

Set the required `ami_id` in each environment's `dev.tfvars` or `prod.tfvars` file to an AMI available in that environment's AWS Region.

## CI/CD

[`.github/workflows/terraform.yml`](.github/workflows/terraform.yml) validates and then creates a Terraform plan for pull requests and pushes. It never applies infrastructure automatically.

Target branch determines the validation environment:

| Branch or PR target | Terraform environment | S3 state key |
| --- | --- | --- |
| `dev` | `dev` | `ec2/dev/terraform.tfstate` |
| `prod` | `prod` | `ec2/prod/terraform.tfstate` |

Use **Run workflow** in GitHub Actions for every state-changing operation. Select the target environment and one of these operations:

- `plan` — creates a saved execution plan and uploads it as a seven-day workflow artifact.
- `apply` — downloads and applies the exact saved plan artifact from the current workflow run.
- `destroy` — creates and uploads a saved `terraform plan -destroy`; the manual execution job downloads and applies that exact destroy plan.

For each GitHub Environment (`dev` and `prod`), configure:

- The CI/CD workflow is fixed to AWS Region `us-east-1`; the environment `dev.tfvars` and `prod.tfvars` files must use the same region.
- The workflow uses `amzn-s3-class-bucket2222` for dev and `amzn-s3-class-bucket3333` for prod.
- Secret `AWS_ACCESS_KEY_ID` — the IAM access key ID for the environment.
- Secret `AWS_SECRET_ACCESS_KEY` — the matching IAM secret access key.

Protect the `prod` GitHub Environment with required reviewers to require approval before manual apply or destroy runs. Use a least-privilege IAM user or credentials limited to the EC2 and scoped S3 state permissions required by the configuration. Rotate these keys regularly.