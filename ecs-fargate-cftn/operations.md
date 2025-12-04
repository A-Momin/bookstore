1. **Create a stack**: To create a stack using the AWS CLI saved in a file called `ecs-django-bs-capacity-provider.yaml`, run the following command.

    - `$ aws cloudformation create-stack --stack-name ecs-django-bs-capacity-provider --template-body file:///Users/am/mydocs/Software_Development/Web_Development/django-courses/bookstore/ecs-fargate-cftn/ecs-django-bs-capacity-provider.yaml --region us-east-1 --capabilities CAPABILITY_NAMED_IAM`
      → to create a stack. The `--capabilities` flag is required to create an Amazon ECS task execution role as specified in the template. You can also specify the `--parameters` flag to customize the template parameters.

    - `$ aws cloudformation describe-stacks --stack-name ecs-django-bs-capacity-provider --region us-east-1`
      → describe-stacks to check the status of stack creation.

2. **Update Stack**:

    - `$ aws cloudformation update-stack --stack-name ecs-django-bs-capacity-provider --template-body file:///Users/am/mydocs/Software_Development/Web_Development/django-courses/bookstore/ecs-fargate-cftn/ecs-django-bs-capacity-provider.yaml --capabilities CAPABILITY_NAMED_IAM --region us-east-1`

3. **Verify Amazon ECS resource creation**: To ensure that Amazon ECS resources are created correctly, follow these steps.

    - `$ aws ecs list-task-definitions` → Run the following command to list all task definitions in an AWS Region.

    - `$ aws ecs list-clusters` → Run the following command to list all clusters in an AWS Region.

    - `$ aws ecs list-services --cluster ecs-django-bs-capacity-provider-cluster`
      → Run the following command to list all services in the cluster ecs-django-bs-capacity-provider-cluster.

    - `$ aws cloudformation describe-stacks --stack-name ecs-django-bs-capacity-provider --region us-east-1 --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerURL`].OutputValue' --output  text`
    - `$ aws cloudformation describe-stacks --stack-name ecs-django-bs-capacity-provider --region us-east-1 --query 'Stacks[0].Outputs[?OutputKey==`PublicSubnet1`].OutputValue' --output  text`
      → Run the following command to retrieve outputs of the created stack.

4. **Clean up**:

    - `$ aws cloudformation delete-stack --stack-name ecs-django-bs-capacity-provider`
      → To clean up the resources you created, run the following command.
