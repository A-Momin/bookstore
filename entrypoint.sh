
cd /bookstore
# python manage.py runserver 0.0.0.0:8000
gunicorn core.wsgi:application --bind 0.0.0.0:8000


# `--bind 0.0.0.0:8000` This specifies the host and port on which Gunicorn should bind and listen for incoming connections. 
    # `0.0.0.0`` means that Gunicorn will listen on all available network interfaces, 
    # `8000` is the port number. This means that the application will be accessible externally on port 8000.