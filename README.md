![Docker + MariaDB](https://cloud.githubusercontent.com/assets/6241518/4245631/8db69fba-3a3c-11e4-8294-244919e4af7c.jpg)

docker-mariadb is a CentOS-based Docker image for MariaDB containers.

## Getting the image
This image is published in the [Docker Hub](https://registry.hub.docker.com/). Simply run the below command to get it on your machine:

```bash
docker pull dylanlindgren/docker-mariadb
```
## Understanding the image
This image adheres to the principle of having a docker container for each process. Therefore there is absolutely no need to jump inside the container during build or operation of the container.

All data is redirected to the `/data/mariadb/data` location and when this is mapped to the host using the `-v` switch then the container is completely disposable.

The startup script (which is the containers default entrypoint) checks `/data/mariadb`, and if it's empty it initialises it by running the `/usr/bin/mysql_install_db` command, and then runs `/usr/bin/mysqld_safe` with an initial SQL file which ensures the database is securely configured for remote access. If the `/data/mariadb` folder contains data then it just runs `/usr/bin/mysqld_safe`.

The steps that are performed to secure the database were taken from [howtolamp.com](http://howtolamp.com/lamp/mysql/5.6/securing/). In summary the script:

- Deletes anonymous users
- Deletes full access to the `test` database
- Deletes full access to databases beginning in `test`
- Deletes the `test` user
- Sets the `root` password as `abc123` **Note - you should change this!!**
- Creates a `docker` user with full permissions to all databases from all hosts with the password `docker` **Note - you should change this**

## Creating and running the container
To create and run the container:
```bash
docker run --privileged=true -v /data/mariadb:/data/mariadb:rw -p 3306:3306 -d --name mariadb dylanlindgren/docker-mariadb
```
 - `-p` publishes the container's 3306 port to 3306 on the host
 - `--name` sets the name of the container (useful when starting/stopping).
 - `-v` maps the `/data/mariadb` folder as read/write (rw).
 - `-d` runs the container as a daemon

To stop the container:
```bash
docker stop mariadb
```

To start the container again:
```bash
docker start mariadb
```
### Running as a Systemd service
To run this container as a service on a [Systemd](http://www.freedesktop.org/wiki/Software/systemd/) based distro (e.g. CentOS 7), create a unit file under `/etc/systemd/system` called `mariadb.service` with the below contents
```bash
[Unit]
Description=MariaDB Docker container (dylanlindgren/docker-mariadb)
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker stop mariadb
ExecStartPre=-/usr/bin/docker rm mariadb
ExecStartPre=-/usr/bin/docker pull dylanlindgren/docker-mariadb
ExecStart=/usr/bin/docker run --privileged=true -v /data/mariadb:/data/mariadb:rw -p 3306:3306 -d --name mariadb dylanlindgren/docker-mariadb
ExecStop=/usr/bin/docker stop mariadb

[Install]
WantedBy=multi-user.target
```
Then you can start/stop/restart the container with the regular Systemd commands e.g. `systemctl start mariadb.service`.

To automatically start the container when you restart enable the unit file with the command `systemctl enable mariadbservice`.
