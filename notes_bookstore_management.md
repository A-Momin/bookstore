### Chat GPT

-   Search 'ChatGPT':

    -   various ways of registering a model with admin site in Django
    -   write a Jenkins end-to-end pipeline with bash script for each stage for a dockerized Django web app
    -   write a github workflow file to test, build docker image and push it into the docker registry and deploy on aws EC2 instance of a Django project on ubuntu server whenever push/pull_request at master branch

### Important packages

-   `$ pip install django-countries django-debug-toolbar stripe`
-   `$ python3 manage.py collectstatic -- no-input`

---

-   <details><summary style="font-size:25px;color:#C71585">when and How to run "python manage.py collectstatic" command for a Django app deployed into AWS ECS with EC2-launch type?</summary>

    The `python manage.py collectstatic` command should be run **every time** you deploy a new version of your Django application that includes changes to static files (CSS, JavaScript, images, etc.).

    In the context of an AWS ECS deployment with the EC2 launch type, the execution of this command is typically handled **during the Docker image build process** or **as a step in your ECS Task Definition's entrypoint script**.

    ***

    ## 📅 When to Run `collectstatic`

    The primary goal of `collectstatic` in a production environment is to gather all static files from your Django apps and consolidate them into the single directory specified by your **`STATIC_ROOT`** setting.

    -   **Trigger:** It must be run whenever you make a change to any static file or add a new Django app with its own static files.
    -   **Purpose in Production:** After running, the files in `STATIC_ROOT` are ready to be served by a dedicated, high-performance web server (like Nginx, a separate container, or AWS S3), rather than relying on Django itself, which is inefficient.

    ***

    ## ⚙️ How to Run `collectstatic` in ECS/EC2

    For a containerized Django application deployed via ECS/EC2, the command should generally be executed as part of a **pre-start step** within the container lifecycle. There are two standard and recommended approaches.

    ### 1\. **Preferred Method: Run during Docker Image Build (Best for S3)**

    If you are using **AWS S3** (via `django-storages`) to host your static files (which is the recommended approach for production Django on AWS), you should run `collectstatic` when building your Docker image.

    #### **Docker Build Step:**

    In your production `Dockerfile`, you'll typically run `collectstatic` **after** copying your application code and installing dependencies, but **before** defining the final execution command.

    ```dockerfile
    # Dockerfile (Example snippet)

    # 1. Install dependencies
    # ...

    # 2. Configure Django-Storages settings (ensure S3 environment variables are set or available)
    # ...

    # 3. Copy application code
    COPY . /usr/src/app/

    # 4. RUN collectstatic *during the image build*
    # This command collects the files and, if django-storages is configured,
    # uploads them directly to the S3 bucket.
    RUN python manage.py collectstatic --noinput

    # 5. Define the command to start the web server (e.g., Gunicorn)
    # CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
    ```

    -   **Benefit:** The static file collection/upload happens once during a reliable build process, ensuring all ECS tasks pull a complete image without needing to run the command at startup.
    -   **Requirement:** Your Docker build environment must have the necessary AWS credentials or IAM role permissions to upload files to your S3 bucket.

    ### 2\. **Alternative Method: Run via Entrypoint Script (For Local Volume Serving)**

    If you are instead collecting static files to a directory **inside the container** (e.g., `STATIC_ROOT = '/vol/web/static'`) to be served by an Nginx sidecar or to be mounted to the host EC2 instance for a web server, you can execute the command at the start of the container.

    #### **Task Definition/Entrypoint Script:**

    1.  **Create a script (e.g., `entrypoint.sh`):**

        ```bash
        #!/bin/bash

        # 1. Run migrations
        python manage.py migrate --noinput

        # 2. Run collectstatic
        # This collects files to the container's STATIC_ROOT directory
        python manage.py collectstatic --noinput

        # 3. Execute the main command (start Gunicorn)
        exec gunicorn myproject.wsgi:application --bind 0.0.0.0:8000
        ```

    2.  **Use the script in your Dockerfile:**

        ```dockerfile
        # Dockerfile (Example snippet)
        # ...
        COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
        RUN chmod +x /usr/local/bin/entrypoint.sh

        ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
        ```

    <!-- end list -->

    -   **Consideration for EC2 Launch Type:** If you scale up your ECS service (e.g., from 2 tasks to 4 tasks), every new task will run this script. If all tasks are supposed to share a common `STATIC_ROOT` location (e.g., an **EFS mount**), running `collectstatic` on every container start is fine. If they are not sharing and are all uploading to S3, this method is redundant but functional.

    </details>

---

-   <details><summary style="font-size:25px;color:#C71585">Integration of Pytest</summary>

    #### Testing Models [44:33 - 01:11:06]

    ```python
    # store/test/test_models.py
    from django.contrib.auth.models import User
    from django.test import TestCase
    from django.urls import reverse
    from store.models import Category, Product

    ...
    ```

    -   `$ pip install pytest-django`
    -   `$ pip install Faker`
    -   `$ pip install coverage`
    -   `$ python manage.py test` → Run django test
        -   `$ coverage --help` →
        -   `$ coverage run manage.py test`
        -   `$ coverage run --omit='*/.venv/*' manage.py test`
        -   `$ coverage report` → it generates a text-based summary report in the terminal, showing how much of your code was executed during tests. Report coverage stats on modules.
        -   `$ coverage html` → to generate an HTML report showing how much of your Python code is covered by tests. Generates several files in `htmlcov` folder.
            -   open `index.html` file with live server (your browser).

    #### Test an API Endpoint using `curl`.

    -   `$ curl -X POST -F "file=@$ADS/data/demofile.txt" http://localhost:8000/loadings/upload/`
    -   `$ curl -u bbcredcap3@gmail.com:1111 -X POST -F "file=@$ADS/data/demofile.txt" http://localhost:8000/loadings/upload/`

    -   [YT](https://www.youtube.com/playlist?list=PLOLrQ9Pn6caw3ilqDR8_qezp76QuEOlHY">)

        -   [Pytest | Selenium | Python Django - Intro Testing with Pytest, Selenium and Django](https://www.youtube.com/watch?v=o_rubsSu-Ds&list=PLOLrQ9Pn6caw3ilqDR8_qezp76QuEOlHY&index=5)

    -   `$ pip install selenium`

    #### MISC

    ```python
    import pytest
    from django.contrib.auth.models import User

    @pytest.fixture(params=["admin", "staff", "anonymous"])
    def user_role(request, db):
        role = request.param
        if role == "admin":
            return User.objects.create_superuser("admin", "admin@example.com", "password")
        elif role == "staff":
            return User.objects.create_user("staff", "staff@example.com", "password", is_staff=True)
        else:
            return None  # anonymous

    def test_access_control(client, user_role):
        if user_role:
            client.force_login(user_role)
        response = client.get("/some-protected-view/")

        if user_role is None:
            assert response.status_code == 302  # redirect to login
        elif user_role.is_superuser:
            assert response.status_code == 200
        elif user_role.is_staff:
            assert response.status_code == 200
    ```

    -   **Why We Need `db`**:

        -   ✅ Purpose:

            The `db` fixture is a built-in **pytest-django** fixture that:

            -   Sets up a test database if one isn’t already set.
            -   Allows your fixture or test to **interact with the database** (e.g., create users).

        -   📌 Why it's needed here:

            You're using `User.objects.create_user(...)`, which **requires database access**. Without including `db`, you'll get an error like:

            ```
            django.core.exceptions.ImproperlyConfigured: Database access not allowed, use the "db" pytest fixture to enable it.
            ```

    -   **Why We Need `client`**:

        -   ✅ Purpose:

            The `client` fixture is also from **pytest-django**. It provides a Django test client instance that you can use to:

            -   Simulate **HTTP requests** (`get`, `post`, etc.)
            -   **Authenticate users** with `client.force_login(...)`
            -   Test views and their responses like a browser would

        -   📌 Why it's needed here:

            You’re simulating access to a view (`/some-protected-view/`) and optionally authenticating a user:

            ```python
            client.force_login(user_role)  # logs in the user
            response = client.get("/some-protected-view/")  # makes the request
            ```

    </details>

---

-   <details><summary style="font-size:25px;color:#C71585">MISC</summary>

    -   [7 Critical Django Production Server Settings to Configure Before Going Live](https://www.youtube.com/watch?v=mAeK4Ia4fk8)
        -   `$ python manage.py check --deploy`

    </details>

---

-   <details><summary style="font-size:25px;color:#C71585">Jenkins Pipeline Configurations</summary>

    #### Allow Jenkins User to Invoke Docker Command

    -   Run the following commands across all the Jenkins agents and remote servers

        1.  `$ sudo usermod -aG docker jenkins` -> Add 'jenkins' user to 'docker' group
        2.  `$ sudo systemctl restart jenkins`

    #### Required Jenkins Plugins

    -   Install following plugins in the Jenkins master.

        1. CloudBees Docker Build and Publish Plugin
        2. Docker Pipeline
        3. SSH Agent Plugin

    #### Script Descriptions

    -   `JOB_NAME` → The name you give at the job creation through Jenkins Web UI.

    #### Facilitate SSH access

    -   `$ ssh-keygen -f ~/.ssh/jenkins_master_to_slave -t rsa -P ""` -> Generate SSh key so that master can ssh into the slave
    -   `$ ssh -o StrictHostKeyChecking=no -i ~/.ssh/ht_aws.pem ubuntu@44.222.195.42 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/jenkins_master_to_slave.pub`

        -   this command will connect to the remote server `___.___.___.___` as the ubuntu user using SSH, append the content of the `jenkins_master_to_slave.pub` file to the `authorized_keys` file in the `~/.ssh/` directory on the remote server, and bypass any host key checking prompts.

    -   <details><summary style="font-size:20px;color:magenta">Add a Permanent Agent step by step</summary>

        </details>

    -   <details><summary style="font-size:20px;color:magenta">Serving Static Files</summary>

        -   [django-storages docs](https://django-storages.readthedocs.io/en/latest/backends/amazon-S3.html)
        -   [Django Static Files in Production on DigitalOcean Spaces docs](https://www.codingforentrepreneurs.com/blog/django-static-files-digitalocean-spaces/)

        -   `$ python manage.py collectstatic --no-input`

        -   Needed packages
            -   `$ pip install django-storages boto3`

        </details>

    -   <details><summary style="font-size:20px;color:magenta">Create a Pipeline step by step</summary>

        </details>

    </details>
