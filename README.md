# Terraform AWS Event architecture

![event-architecture](https://github.com/imdounia/terraform_aws/assets/78279860/55bbe7f4-539f-4928-8cf4-933c22fec0b5)

This repository contains the code and configuration files to build a small event architecture using AWS Lambda and DynamoDB. The infrastructure created will include an API that allows adding a JOB to a DynamoDB table. Each new JOB added to the table will trigger the processing of that JOB through a Lambda function.

# Objective
The objective of this project is to demonstrate a simple event-driven architecture where incoming events are processed asynchronously using AWS Lambda and DynamoDB. The service accepts two types of jobs: addToS3 and addToDynamoDB. Depending on the nature of the job, the Lambda function will either add the data to an S3 bucket or insert it into a DynamoDB table.

# Setup
* Update the terraform.tfvars file with your AWS credentials and desired configuration. <br>
<code>access_key = "<your-access-key>"</code><br>
<code>secret_key = "<your-secret-key>"</code>

* Initialize Terraform and create the infrastructure.<br>
<code>terraform init</code><br>
<code>terraform apply</code>

* Once the infrastructure is created, you will see the API Gateway endpoint URL in the Terraform output. Use this URL to send HTTP POST requests to add jobs to the DynamoDB table. The job_type should be either 'addToS3' or 'addToDynamoDB' ❗❗

Enjoy ! 😆👊🤘💓🙈

