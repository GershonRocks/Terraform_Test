# Terraform_Test
# AWS Terraform Configuration README

This repository contains a Terraform template for setting up various AWS resources across multiple regions (`us-east-1` and `us-west-1`). The resources include security groups, IAM roles and policies, and EC2 instances, with a focus on enabling SSH and ICMP access for AWS Systems Manager (SSM) in both regions.

## Prerequisites

Before applying this Terraform template, ensure you have the following:

- AWS Account
- AWS CLI installed and configured
- Terraform 0.12.x or later

## Configuration Details

The template configures the following resources:

### Providers

- Two AWS providers for different regions:
  - `aws.east` for `us-east-1`
  - `aws.west` for `us-west-1`

### AWS Security Groups

- `aws_security_group.ssm_access_east`: A security group in the `us-east-1` region to allow SSH (port 22) and ICMP (-1) ingress and ICMP egress.
- `aws_security_group.ssm_access_west`: Similar to `ssm_access_east`, but for the `us-west-1` region.

### AWS IAM Role and Instance Profile

- `aws_iam_role.ec2_ssm_role`: An IAM role with a trust relationship allowing actions from the EC2 service.
- `aws_iam_instance_profile.ec2_ssm_instance_profile`: Instance profile associated with the above IAM role.
- `aws_iam_role_policy_attachment.ssm_managed_instance_core`: Attaches the `AmazonSSMManagedInstanceCore` policy to the `ec2_ssm_role`.

### AWS EC2 Instances

- `aws_instance.instance_east`: An EC2 instance in `us-east-1` using the `t2.micro` instance type and the previously defined security group and IAM instance profile.
- `aws_instance.instance_west`: Similar to `instance_east`, but deployed in `us-west-1`.

## Usage

To use this template:

1. Clone the repository to your local machine.
2. Navigate to the cloned directory.
3. Initialize Terraform:

   ```sh
   terraform init
   ```

4. Apply the Terraform plan:

   ```sh
   terraform apply
   ```

5. Confirm the plan and wait for the resources to be created.

## Contributing

Feel free to fork the repository and submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Note: Be aware of AWS charges that may occur when creating resources. Always review the Terraform plan output before applying.*

