FROM linuxserver/baseimage
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# copy sources.list
COPY sources.list /etc/apt/

# set some environment variables for mariadb to give us our paths
ENV INSTALL_LIST="mysql-server mysqltuner"
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
$INSTALL_LIST -qy && \

# clean up
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql && \
mkdir -p /var/lib/mysql

#Adding Custom files
COPY defaults/ /defaults/
COPY init/ /etc/my_init.d/
COPY services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh

# set volumes and ports
VOLUME /config
EXPOSE 3306
