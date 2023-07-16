
# This image is build upon Debian 11
FROM python:3.7

WORKDIR /bookstore
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

RUN apt-get update
RUN apt-get -y install sudo systemd curl vim ufw

RUN echo 'root:0000' | chpasswd
RUN useradd -ms /bin/bash Shah && echo "Shah:1111" | chpasswd && adduser Shah sudo

# gives the user `Shah` the ability to use sudo without a password prompt.
RUN sed -i '$ a Shah ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

USER Shah
WORKDIR /home/Shah/

WORKDIR /bookstore

# 'CMD' is executed from 'WORKDIR'
CMD ["/bin/bash", "/bookstore/entrypoint.sh"]
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
