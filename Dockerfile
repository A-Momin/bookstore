
# This image is build upon Debian 11
FROM python:3.11-slim-bullseye

WORKDIR /bookstore
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

RUN apt-get update
RUN apt-get -y install sudo systemd curl vim ufw

RUN echo 'root:0000' | chpasswd
RUN useradd -ms /bin/bash Shah && echo "Shah:1111" | chpasswd && adduser Shah sudo

# gives the user `Shah` the ability to use sudo without a password prompt.
RUN sed -i '$ a Shah ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

COPY entrypoint.sh /bookstore/entrypoint.sh
RUN chmod +x /bookstore/entrypoint.sh

COPY . /bookstore/

RUN chown -R Shah:Shah /bookstore

# NOTE: Replace 'dummy_key' with a sensible placeholder, if your settings allow for it.
# Defining the placeholder ENV variable in the Dockerfile to get your build working immediately. You should then configure your ECS Task Definition to inject the actual, secret value of STRIPE_SECRET_KEY into the container when it runs.
ENV STRIPE_SECRET_KEY="DUMMY_SECRET_FOR_COLLECTSTATIC_ONLY"

# Define the required STATIC_ROOT setting
# This is a temporary container path for collectstatic to target.
ENV STATIC_ROOT="/tmp/static_collection"

USER Shah
WORKDIR /bookstore


# 4. RUN collectstatic *during the image build*
# This command collects the files and, if django-storages is configured,
# uploads them directly to the S3 bucket.
RUN python manage.py collectstatic --noinput


# 'CMD' is executed from 'WORKDIR'
CMD ["/bin/bash", "/bookstore/entrypoint.sh"]
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
