#!/bin/bash

createsuperuser(){
    # Purpose: Create super users for your Django application.
    python manage.py createsuperuser --email bbcredcap3@gmail.com --user_name bbcredcap3
    python manage.py createsuperuser --email A.Momin.NYC@gmail.com --user_name A.Momin.NYC
}

dumpdata(){
    : 'Purpose: Dump data from your model into the Django fixtures.
    
    Args:
        ($1): Django App name
        ($2): Model name of the given App.
        ($3): Name of the output file.
    
    Example: 
        python manage.py dumpdata store.Product -o store/fixtures/books.json --format json --indent 2
    '
    python manage.py dumpdata $1.$2 -o $1/fixtures/$3.json --format json --indent 2
}

loaddata(){
    : 'Purpose: Load data into Django database using fixture.
    
    Args:
        ($1): Django fixture-file name containing the data.
    Example:
        python manage.py loaddata fixture_name.json
    '
    python manage.py loaddata $1
}

python_shell(){
    python manage.py shell
}

run(){
    python manage.py runserver
}

delete_migrations(){
    find . -type f -name '*_initial.py' -delete
    ## Note that the `-delete` option is a non-POSIX extension to find, so it may not be available on all systems. In that case, you can use the -exec option to run the rm command on each file:
    # find /path/to/directory -type f -name '*.txt' -exec rm {} \;
}
