
cd /bookstore
# python manage.py runserver 0.0.0.0:8000
gunicorn core.wsgi:application --bind 0.0.0.0:8000
