# set base os
FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

# set some environment variables for mariadb to give us our paths
ENV APTLIST="mysql-server mysqltuner"
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/databases

# set debconf selections to not show apt messages about mysql data paths etc..
RUN { echo mysql-community-server mysql-community-server/data-dir select ''; \
echo mysql-community-server mysql-community-server/root-pass password ''; \
echo mysql-community-server mysql-community-server/re-root-pass password ''; \
echo mysql-community-server mysql-community-server/remove-test-db select false; } | debconf-set-selections

# update apt and install packages
RUN apt-get update && \
apt-get install \
$APTLIST -qy && \

# clean up
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql && \
mkdir -p /var/lib/mysql

# Tweak my.cnf
RUN sed -i 's/key_buffer\b/key_buffer_size/g' /etc/mysql/my.cnf && \
sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf && \
sed -i s#/var/log/mysql#/config/log/mysql#g /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 abc/g' /etc/mysql/my.cnf && \
sed -i -e "s#\(datadir.*=\).*#\1 $DATADIR#g" /etc/mysql/my.cnf && \
cp /etc/mysql/my.cnf /defaults/my.cnf

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh

# set volumes and ports
VOLUME /config
EXPOSE 3306
