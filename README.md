### How to build the image and spin up the container

-   `$ docker build -t bbcredcap3/harness:bs-img .` -> `registry/repository:tag`
-   `$ docker-compose up -d`
-   `$ docker-compose up -d --build`
-   `$ docker-compose down`

#### Alternative to `$ docker-compose up -d`

-   `$ docker run -dit --rm --privileged -p 8010:8000 -v pwd:/bookstore -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=bs-cont bbcredcap3/harness:bs-img`

### How to run test with 'coverage'?

-   `$ coverage run --omit='*/.venv/*' manage.py test`
