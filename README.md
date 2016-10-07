[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/mysql
[![](https://images.microbadger.com/badges/image/linuxserver/mysql.svg)](http://microbadger.com/images/linuxserver/mysql "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/mysql.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/mysql.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-mysql)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-mysql/)
[hub]: https://hub.docker.com/r/linuxserver/mysql/

MySQL is the world's most popular open source database. With its proven performance, reliability and ease-of-use, MySQL has become the leading database choice for web-based applications, covering the entire range from personal projects and websites, via e-commerce and information services, all the way to high profile web properties including Facebook, Twitter, YouTube, Yahoo! and many more. 

[![mysql](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mysql-git.png)][mysqlurl]
[mysqlurl]: https://www.mysql.com/

## Usage

```
docker create \
--name=mysql \
-p 3306:3306 \
-e PUID=<UID> \
-e PGID=<GID> \
-e MYSQL_ROOT_PASSWORD=<DATABASE PASSWORD> \
-v </path/to/appdata>:/config \
linuxserver/mysql
```

**Parameters**

* `-p 3306` - mysql port
* `-v /config` - Contains the db itself and all assorted settings. 
* `-e MYSQL_ROOT_PASSWORD` - set this to root password for installation (minimum 4 characters)
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it mysql /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

If you didn't set a password during installation, (see logs for warning) use mysqladmin -u root password <PASSWORD> to set one at the docker prompt... NOTE changing the MYSQL_ROOT_PASSWORD variable after the container has set up the initial databases has no effect. It is also advisable to edit the run command or template/webui after setup and remove reference to this variable.

Find custom.cnf in /config for config changes (restart container for them to take effect) , the databases in /config/databases and the log in /config/log/myqsl.

The container also has mysqltuner included which can either be run from within the container by exec'ing in or externally by issuing `docker exec -it mysql mysqltuner`. It will prompt for credentials if you have set a password for root user.


## Info

* Shell access whilst the container is running: `docker exec -it mysql /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f mysql`


## Versions

+ **14.09.16:** Bump version due to USN-3078-1.
+ **14.03.16:** Remove autoupdating, between some version updates the container breaks, change to adding config options in init script, use custom.cnf instead of my.cnf
+ **26.01.16:** Change user of mysqld_safe script to abc, better unclean shutdown handling on restart.
+ **12.08.15:** Initial Release.
