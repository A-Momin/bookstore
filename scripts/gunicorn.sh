#!/bin/bash

source .venv/bin/activate

cd /var/lib/jenkins/workspace/bookstore

python3 manage.py makemigrations
python3 manage.py migrate
# python3 manage.py collectstatic -- no-input

echo "Migrations done"

cd /var/lib/jenkins/workspace/bookstore

sudo cp -rf scripts/gunicorn.socket /etc/systemd/system/
sudo cp -rf scripts/gunicorn.service /etc/systemd/system/

echo "Current User: $USER"
echo "Current Workin Diractory: $PWD"



sudo systemctl daemon-reload
sudo systemctl start gunicorn

echo "Gunicorn has started."

sudo systemctl enable gunicorn

echo "Gunicorn has been enabled."

sudo systemctl restart gunicorn


sudo systemctl status gunicorn

