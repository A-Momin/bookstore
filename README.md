### How to build the image and spin up the container

-   `$ docker build -t bbcredcap3/harness:bs-img .`
-   `$ docker-compose up -d`
-   `$ docker-compose up -d --build`
-   `$ docker-compose down`

#### Alternative to `$ docker-compose down`

-   `$ docker run -dit --rm --privileged -p 8010:8000 -v `pwd`:/bookstore -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=bs-cont bbcredcap3/harness:bs-img`
