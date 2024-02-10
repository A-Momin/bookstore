#!/bin/bash

djrun(){
    python manage.py runserver localhost:${1:-8000}
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
    rm -fr /Users/am/mydocs/Software_Development/Web_Development/django-courses/bookstore/media/images/*
    python manage.py createsuperuser --email AMominNJ@gmail.com --user_name admin --noinput;
    loaddata categories.json;
    loaddata books.json;
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