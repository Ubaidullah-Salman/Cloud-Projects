Serverless Form Web App on AWS
A fully serverless web application built on AWS. Users fill out a contact form on a static website, and their submission is processed by AWS Lambda and stored in DynamoDB — with zero servers to manage.

Architecture
Show Image
User Browser → S3 (Static Website) → API Gateway → Lambda (Python) → DynamoDB

AWS Services Used
ServicePurposeS3Hosts the static HTML frontendAPI GatewayExposes a POST /submit HTTP endpointAWS LambdaProcesses form data (Python 3.12)DynamoDBStores form submissionsIAMGrants Lambda permission to write to DynamoDB

Project Structure
Serverless-Form-App/
├── index.html           # Frontend form (hosted on S3)
├── lambda_function.py   # Python Lambda handler
├── README.md
└── Images/
    └── Infra.png        # Architecture diagram

How to Deploy
1. Create DynamoDB Table

Table name: FormSubmissions
Partition key: id (String)

2. Create Lambda Function

Runtime: Python 3.12
Paste the code from lambda_function.py
Attach AmazonDynamoDBFullAccess policy to the Lambda execution role

3. Create API Gateway

Type: HTTP API
Integration: Lambda (FormHandler)
Route: POST /submit
Enable CORS: Allow origin *, method POST
Stage: $default with auto-deploy ON

4. Update Frontend

Open index.html
Replace YOUR_API_GATEWAY_URL with your actual API Gateway Invoke URL

5. Host on S3

Create an S3 bucket with static website hosting enabled
Disable "Block all public access"
Add a public bucket policy
Upload index.html
Access via the S3 website endpoint URL


Live Demo

Form live at: YOUR_S3_WEBSITE_URL
Submissions stored in DynamoDB table: FormSubmissions


What I Learned

Building event-driven serverless architectures on AWS
Connecting API Gateway to Lambda with CORS configured correctly
Writing Python Lambda handlers that interact with DynamoDB using boto3
Hosting static websites on S3 with public access policies
End-to-end AWS service integration without managing any servers
