# CRD operations with AWS api gateway, Lambda and dynamoDB using Terraform
using Terraform Created API Gateway with GET,POST and Delete methods , Lambda function to process the data and DynamoDB for storing the data. User sends the request through api gateway for the particular operation then lambda gets the request and process the data from dynamodb and return the response to api gateway.


Running the demo
1.Clone the repo.

2.change the profile in provider.tf file.

3.open cmd, go to your file location and run below commands-

terraform init

terraform plan

terraform apply -auto-approve