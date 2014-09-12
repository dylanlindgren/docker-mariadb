FROM centos:centos7

MAINTAINER "Dylan Lindgren" <dylan.lindgren@gmail.com>

# Install MariaDB
ADD config/MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN yum update -y
RUN yum install -y MariaDB-server MariaDB-client

# Configure MariaDB
ADD config/my.cnf /etc/my.cnf

# All the MariaDB data that you'd want to backup will be redirected here
RUN mkdir /data
VOLUME ["/data/mariadb"]

# Port 3306 is where MariaDB listens on
EXPOSE 3306

# These scripts will be used to launch MariaDB and configure it
# securely if no data exists in /data/mariadb
ADD config/mariadb-start.sh /opt/bin/mariadb-start.sh 
ADD config/mariadb-setup.sql /opt/bin/mariadb-setup.sql
RUN chmod u=rwx /opt/bin/mariadb-start.sh
RUN chown mysql:mysql /opt/bin/mariadb-start.sh /opt/bin/mariadb-setup.sql /data/mariadb

# run all subsequent commands as the mysql user
USER mysql

ENTRYPOINT ["/opt/bin/mariadb-start.sh"]
