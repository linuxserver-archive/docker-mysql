# set base os
FROM linuxserver/baseimage

MAINTAINER Mark Burford <sparklyballs@gmail.com>

# set some environment variables for mariadb to give us our paths
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/databases

# set ports
EXPOSE 3306


# set debconf selections to not show apt messages about mysql data paths etc..
RUN { echo mysql-community-server mysql-community-server/data-dir select ''; \
echo mysql-community-server mysql-community-server/root-pass password ''; \
echo mysql-community-server mysql-community-server/re-root-pass password ''; \
echo mysql-community-server mysql-community-server/remove-test-db select false; } | debconf-set-selections

# update apt and install packages
RUN apt-get update && \
apt-get install \
mysql-server mysqltuner -qy && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# empty /var/lib/mysql as we are using our own data folders
rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql

# Tweak my.cnf
RUN sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf && \
sed -i s#/var/log/mysql#/config/log/mysql#g /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 abc/g' /etc/mysql/my.cnf && \
sed -i -e "s#\(datadir.*=\).*#\1 $DATADIR#g" /etc/mysql/my.cnf

#Adding Custom files
RUN mkdir -p /defaults 
RUN cp /etc/mysql/my.cnf /defaults/my.cnf
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh

