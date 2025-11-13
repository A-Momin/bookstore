#!/bin/bash

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TERRAFORM_DIR="$PROJECT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# =============================================================================
# =============================================================================

create_uv_env(){
    : 'Create a new Python virtual environment using `uv`.

    Args:
        ($1): Name of the virtual environment to create.
    
    Example:
        create_uv_env myenv
    '
    uv venv $UV/"$1" --python 3.11
}

djrun(){
    python manage.py runserver 0.0.0.0:${1:-8000}
}

createsuperuser(){
    : 'Create super users for your Django application using the DJANGO_SUPERUSER_<PARAMETER_NAME> environment veriables.'

    python manage.py createsuperuser --email AMominNJ@gmail.com --user_name admin --noinput
    # python manage.py createsuperuser --user_name admin --noinput
}

dumpdata(){
    : 'Purpose: Dump data from your model into the Django fixtures.
    
    Args:
        ($1): Django App name
        ($2): Model name of the given App.
        ($3): Name of the output file.
    
    Example:
        dumpdata store Product books
    '
    # python manage.py dumpdata store.Product -o store/fixtures/books.json --format json --indent 2
    python manage.py dumpdata $1.$2 -o $1/fixtures/$3.json --format json --indent 2
}

loaddata(){
    : 'Purpose: Load data into Django database using fixture.

    NOTE:
        Create a super user with ID equal to 1 before loading the data.
    Args:
        ($1): Django fixture-file name (fixture_name.json) containing the data.
    Example:
        loaddata books.json
    '
    # python manage.py loaddata books.json
    python manage.py loaddata $1
}

djshell(){
    python manage.py shell
}

migrate_data(){
    # The `makemigrations` command looks at all your available models and creates migrations for whichever tables don’t already exist.
    python manage.py makemigrations
    
    # `migrate` runs the migrations and creates tables in your database, as well as optionally providing much richer schema control.
    python manage.py migrate
}

delete_migrations(){
    find . -type f -name '*_initial.py' -delete
    ## Note that the `-delete` option is a non-POSIX extension to find, so it may not be available on all systems. In that case, you can use the -exec option to run the rm command on each file:
    # find /path/to/directory -type f -name '*.txt' -exec rm {} \;
    find . -type f -name '*db.sqlite3' -delete
}

refresh_database(){
    delete_migrations;
    migrate_data;
    # rm -fr /Users/am/mydocs/Software_Development/Web_Development/django-courses/bookstore/media/images/*
    python manage.py createsuperuser --email AMominNJ@gmail.com --user_name admin --noinput;
    # loaddata categories.json;
    # loaddata books.json;
}

delete_user(){
    python manage.py shell -c "from account.models import UserBase; UserBase.objects.filter(email='${1:-A.Momin.NYC@gmail.com}').delete()"
}

git_info(){
    echo "List of remote URLs:"
    git remote -v
    git config --get user.name
    git config --get user.email
    git log --graph --oneline --decorate --all
    echo "List of branches created so far:"
    git branch --list
}

add_github_secrets(){
    : ' Adds secrets to the Github
    '
    gh secret set DOCKERHUB_USERNAME --body ${DOCKERHUB_USERNAME}
    gh secret set DOCKERHUB_PASSWORD --body ${DOCKERHUB_PASSWORD}
    gh secret set DOCKER_REGISTRY --body ${DOCKER_REGISTRY}
    gh secret set DOCKER_REPOSITORY --body ${DOCKER_REPOSITORY}
    gh secret set STRIPE_SECRET_KEY --body ${STRIPE_SECRET_KEY}
    gh secret set STRIPE_PUBLISHABLE_KEY --body ${STRIPE_PUBLISHABLE_KEY}
}

remove_github_secrets(){
    : ' Removes secrets to the Github
    '
    gh secret remove DOCKERHUB_USERNAME
    gh secret remove DOCKERHUB_PASSWORD
    gh secret remove DOCKER_REGISTRY
    gh secret remove DOCKER_REPOSITORY
    gh secret remove STRIPE_SECRET_KEY
    gh secret remove STRIPE_PUBLISHABLE_KEY
}

git_add_commit_push(){
    : ' Adds, commits, and pushes changes to the Git repository.
    
    Args:
        ($1): Commit message.
    
    Example:
        git_add_commit_push "Updated README"
    '
    git add .
    git commit -m "$1"
    git push origin $2
}

# Function to build and push Docker image
build_and_push_image() {
    : ' Builds and pushes a Docker image to AWS ECR.
    '
    # local version="$1"
    # local environment="$2"
    local version="latest"
    local ecr_repo_url="530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-ecr-repo"
    local aws_region="us-east-1"
    local environment="blue"

    log "Building Docker image for version $version..."
    
    # Login to ECR
    aws ecr get-login-password --region "$aws_region" | docker login --username AWS --password-stdin "$ecr_repo_url"
    
    # Build image
    docker build -t "$ecr_repo_url:$version" \
        --build-arg DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" \
        --build-arg DJANGO_STRIPE_SECRET_KEY="$DJANGO_STRIPE_SECRET_KEY" \
        --build-arg DJANGO_STRIPE_ENDPOINT_SECRET="$DJANGO_STRIPE_ENDPOINT_SECRET" \
        --build-arg DJANGO_STATIC_ROOT="$DJANGO_STATIC_ROOT" \
        -f Dockerfile .
    
    # docker build -t "$ecr_repo_url:$version" --build-arg DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" --build-arg DJANGO_STRIPE_SECRET_KEY="$DJANGO_STRIPE_SECRET_KEY" --build-arg DJANGO_STRIPE_ENDPOINT_SECRET="$DJANGO_STRIPE_ENDPOINT_SECRET" --build-arg DJANGO_STATIC_ROOT="$DJANGO_STATIC_ROOT" -f Dockerfile .

    # Tag as latest for the environment
    docker tag "$ecr_repo_url:$version" "$ecr_repo_url:$environment-latest"
    
    # Push images
    docker push "$ecr_repo_url:$version"
    docker push "$ecr_repo_url:$environment-latest"
    
    success "Docker image built and pushed successfully"
}
