<details><summary style="font-size:18px;color:Orange">How to build and run the project</summary>

#### How to build the image and spin up the container

-   `$ docker build -t bbcredcap3/harness:bs-img .` -> `registry/repository:tag`
-   `$ docker-compose up -d`
-   `$ docker-compose up -d --build`
-   `$ docker-compose down`

#### Alternative to `$ docker-compose up -d`

-   `$ docker run -dit --rm --privileged -p 8010:8000 -v pwd:/bookstore -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=bs-cont bbcredcap3/harness:bs-img`

#### How to run the project with Gunicorn server?

-   `$ gunicorn core.wsgi:application --bind 0.0.0.0:8000`
-   `$ gunicorn core.wsgi:application --config ./gunicorn_config.py`

#### How to run the project with uWSGI server?

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

#### How to run test with 'coverage'?

-   `$ coverage run --omit='*/.venv/*' manage.py test`

</details>
