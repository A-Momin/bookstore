import boto3, botocore
from botocore.exceptions import ClientError
import os


# boto3.setup_default_session(profile_name="AMominNJ")

REGION = os.environ["AWS_DEFAULT_REGION"]
cf_client = boto3.client("cloudformation", region_name=REGION)

# Read CloudFormation template from a file
with open("/Users/am/mydocs/Software_Development/Web_Development/django-courses/bookstore/ecs-fargate-cftn/ecs-django-bs-capacity-provider.yaml","r") as ecs_cf_template:
    template_body = ecs_cf_template.read()

# Define stack name
stack_name = "ecs-tutorial"

# Define CloudFormation parameters
parameters = [
    # {
    #     "ParameterKey": "VPCId",
    #     "ParameterValue": os.environ["AWS_DEFAULT_VPC"],
    # },
    # {
    #     "ParameterKey": "SubnetIdOne",
    #     "ParameterValue": os.environ["AWS_DEFAULT_SUBNET_A"],
    # },
    # {
    #     "ParameterKey": "SubnetIdTwo",
    #     "ParameterValue": os.environ["AWS_DEFAULT_SUBNET_C"],
    # },
    # {
    #     "ParameterKey": "ImageId",
    #     "ParameterValue": os.environ["AMAZON_LINUX_AMI_ID"],
    # },
    # {"ParameterKey": "InstanceType", "ParameterValue": "t2.micro"},
]

# Create CloudFormation stack
print(f"Creating CloudFormation stack: {stack_name}")
response = cf_client.create_stack(
    StackName=stack_name,
    TemplateBody=template_body,
    Parameters=parameters,
    Capabilities=["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"],  # Required for IAM resources only if your template creates IAM resources
)
