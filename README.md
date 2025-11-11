-   <details><summary style="font-size:25px;color:Orange">How to build and run the project</summary>

    -   <details><summary style="font-size:25px;color:#C71585">Development Server (Mac)</summary>

        -   **How to run the Application in local environment?**

            -   **Activate Django Environment**:

                -   `$ cd path/to/bookstore` → Change directory to the Django project.
                -   `$ git checkout bs-regular` → Checkout the development branch.
                -   `$ source $UV/django/bin/activate` → Activate `django` environment (assumed `uv`-env have created in `$UV` )
                    -   `$ uae django` → Alternative pre-defined shortcut approch to `activate` the `django` environment

            -   **Option-0**: Typical Approch

                -   `$ python manage.py runserver localhost:8000` → Run the Django development server of the Django project.

                    -   **How to run test with 'coverage'?**

                        -   `$ coverage run --omit='*/.venv/*' manage.py test`

            -   **Option-01**: How to run the Application with `Gunicorn` Django Server?

                -   `$ gunicorn core.wsgi:application --bind 0.0.0.0:8000`
                -   `$ gunicorn core.wsgi:application --config ./gunicorn_config.py`

            -   **Option-02**: How to run the Application with `uWSGI` Django Server?

                -   [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/index.html)

                -   Testing uWSGI Server:
                    -   create a python script for testing (uwsgi_testing.py)
                    -   Deploy it on HTTP port 9090:
                        -   `$ uwsgi --http :9090 --wsgi-file uwsgi_testing.py`
                    -   Adding concurrency and monitoring
                        -   `$ uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2`
                            -   This will spawn 4 processes (each with 2 threads), a master process (will respawn your processes when they die) and the HTTP router
                        -   `$ uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191`
                            -   One important task is monitoring. Understanding what is going on is vital in production deployment. The stats subsystem allows you to export uWSGI’s internal statistics as JSON

            -   **Checkout Admin Page**:
                -   `http://localhost:8000/admin/` → `/` at the end matters
                -   `http://localhost:8000/`

        -   **How to run the Application in a Container**

            -   `$ docker build -t bbcredcap3/harness:bs-img .` → `registry/repository:tag`

            -   **Option-1 (`docker-compose`)**:

                -   `$ docker-compose up -d`
                -   `$ docker-compose up -d --build`
                -   `$ docker-compose down`

            -   **Option-2 (`docker run`)**:

                -   `$ docker run -dit --rm --privileged -p 8010:8000 -v pwd:/bookstore -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=bs-cont bbcredcap3/harness:bs-img`

        </details>

    -   <details><summary style="font-size:25px;color:#C71585">Development Server (EC2-AmazonLinux)</summary>

        -   **How to run the Application in local environment?**

            -   **Activate Django Environment**:

                -   `$ git clone --branch bs-regular --single-branch git@gh1:A-Momin/bookstore.git` → Clone the `bookstore` repository from `Github.com`
                -   `$ cd path/to/bookstore` → Change directory to the Django project.
                -   `$ git checkout bs-regular` → Checkout the development branch.
                -   `$ source $UV/django/bin/activate` → Activate `django` environment (assumed `uv`-env have created in `$UV` )
                    -   `$ uae django` → Alternative pre-defined shortcut approch to `activate` the `django` environment

            -   **Option-0**: Typical Approch

                -   `$ python manage.py runserver 0.0.0.0:8000` → Run the Django development server of the Django project.

                    -   **How to run test with 'coverage'?**

                        -   `$ coverage run --omit='*/.venv/*' manage.py test`

            -   **Option-01**: How to run the Application with `Gunicorn` Django Server?

                -   `$ gunicorn core.wsgi:application --bind 0.0.0.0:8000`
                -   `$ gunicorn core.wsgi:application --config ./gunicorn_config.py`

            -   **Option-02**: How to run the Application with `uWSGI` Django Server?

                -   [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/index.html)

                -   Testing uWSGI Server:
                    -   create a python script for testing (uwsgi_testing.py)
                    -   Deploy it on HTTP port 9090:
                        -   `$ uwsgi --http :9090 --wsgi-file uwsgi_testing.py`
                    -   Adding concurrency and monitoring
                        -   `$ uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2`
                            -   This will spawn 4 processes (each with 2 threads), a master process (will respawn your processes when they die) and the HTTP router
                        -   `$ uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191`
                            -   One important task is monitoring. Understanding what is going on is vital in production deployment. The stats subsystem allows you to export uWSGI’s internal statistics as JSON

            -   **Checkout Admin Page**:
                -   `http://<ec2_public_ip_address>:8000/admin/` → `/` at the end matters
                -   `http://<ec2_public_ip_address>:8000/`

        -   **How to run the Application in a Container**

            -   `$ docker build -t 530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-django:bs-img .` → `registry/repository:tag`

            -   **Option-1 (`docker-compose`)**:

                -   `$ docker-compose up -d`
                -   `$ docker-compose up -d --build`
                -   `$ docker-compose down`

            -   **Option-2 (`docker run`)**:

                -   `$ docker run -dit --rm --privileged -p 8010:8000 -e STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY" -v $PWD:/bookstore -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=bs-cont 530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-django:bs-img`

            -   **Push the Docker Image into AWS ECR**: Use the following steps to authenticate and push an image to your repository. For additional registry authentication methods, including the Amazon ECR credential helper, see Registry Authentication .

                -   `$ docker push 530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-django:bs-img`
                    → Run the following command to push this image to your newly created AWS repository

        </details>

    -   <details><summary style="font-size:25px;color:#C71585">Production Server (AWS ECS)</summary>

        -   **Push the Docker Image into AWS ECR from Dev server**: Use the following steps to authenticate and push an image to your repository. For additional registry authentication methods, including the Amazon ECR credential helper, see Registry Authentication .

            -   `$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 530976901147.dkr.ecr.us-east-1.amazonaws.com`

                → Retrieve an authentication token and authenticate your Docker client to your registry. Use the AWS CLI:
                → Note: If you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.

            -   `$ docker build -t bookstore-django .`
                → Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here . You can skip this step if your image is already built:
            -   `$ docker tag bookstore-django:latest 530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-django:latest`
                → After the build completes, tag your image so you can push the image to this repository.
                → `$ docker tag source_image[:tag] target_image[:tag]` → `docker tag source_image[:tag] ecr_registry/repository[:tag]`
            -   `$ docker push 530976901147.dkr.ecr.us-east-1.amazonaws.com/bookstore-django:bs-img`
                → Run the following command to push this image to your newly created AWS repository

        </details>

    </details>
