#!/bin/bash

run(){
    python manage.py runserver
}

createsuperuser(){
    : 'Create super users for your Django application using the DJANGO_SUPERUSER_<PARAMETER_NAME> environment veriables.'

    # python manage.py createsuperuser --email A.Momin.NYC@gmail.com --username A.Momin.NYC --noinput
    python manage.py createsuperuser --noinput
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

pythonshell(){
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

git_info(){
    echo "List of remote URLs:"
    git remote -v
    git config --get user.name
    git config --get user.email
    git log --graph --oneline --decorate --all
    echo "List of branches created so far:"
    git branch –a
}