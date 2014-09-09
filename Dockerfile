FROM centos:latest

MAINTAINER "Dylan Lindgren" <dylan.lindgren@gmail.com>

# Install trusted CA's (needed in the environment this was developed for)
ADD build/certs /tmp/certs
RUN cat /tmp/certs >> /etc/pki/tls/certs/ca-bundle.crt

ADD config/MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN yum update -y
RUN yum install -y MariaDB-server MariaDB-client

ADD config/my.cnf /etc/my.cnf

# DATA VOLUMES
RUN mkdir -p /data/mariadb/
VOLUME ["/data/mariadb"]

# PORTS
EXPOSE 3306

RUN /usr/bin/mysql_install_db --datadir=/data/mariadb --user=mysql

USER mysql

ENTRYPOINT ["/usr/sbin/mysqld"]
