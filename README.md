![https://linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring auto-update on startup, easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io](https://forum.linuxserver.io)
* [IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`
* [Podcast](https://www.linuxserver.io/index.php/category/podcast/) covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/mysql
![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mysql-git.png)

MySQL is the world's most popular open source database. With its proven performance, reliability and ease-of-use, MySQL has become the leading database choice for web-based applications, covering the entire range from personal projects and websites, via e-commerce and information services, all the way to high profile web properties including Facebook, Twitter, YouTube, Yahoo! and many more. 

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



## Updates

* Shell access whilst the container is running: `docker exec -it mysql /bin/bash`
* Upgrade to the latest version: `docker restart mysql`
* To monitor the logs of the container in realtime: `docker logs -f mysql`



## Versions
+ **14.03.2016:** Remove autoupdating, between some version updates the container breaks, change to adding config options in init script, use custom.cnf instead of my.cnf
+ **26.01.2016:** Change user of mysqld_safe script to abc, better unclean shutdown handling on restart.
+ **12.08.2015:** Initial Release. 

