![Magento 2 Docker](https://underser.github.io/static/magento.jpg)

# Docker for Magento 2 development

First of all, thank [rafaelstz](https://github.com/rafaelstz) this project is based on its [developments](https://github.com/clean-docker/Magento2)

### Nginx 1.13 + PHP 7.2 + OPCache + MariaDB + N98 Magerun 2 + XDebug + Redis + Elasticsearch

### Requirements

**MacOS:**

Install [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-OSX).

**Windows:**

Install [Docker](https://docs.docker.com/docker-for-windows/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-Windows).

**Linux:**

Install [Docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) and [Docker-compose](https://docs.docker.com/compose/install/#install-compose).

### How to use

Clone this repository:
```
git clone git@github.com:underser/magento2-docker.git <project_folder>
```
Go to <project_folder>:
```
./init
```
<sup>Script ask you about project name, and link to git repo</sup>

Run:
```
docker-compose up -d
```

After initialization you'll get 6 docker containers running:

| Container  | Ports(host/container)  | Description  |
|---|---|---|
| `<project_name>_apache`  | 80/80 ; 9000:9001  | Contains `Apache 2.4 + PHP 7.1 + OPCache + N98 Magerun 2 + XDebug` |
| `<project_name>_db`  | 3300/3306  | Contains `MariaDB` |
| `<project_name>_elasticsearch`  | 9200/9200  | Contains `Elasticsearch 2.4` |
| `<project_name>_mailhog`  | 1025/1025 ; 8025/8025  | Allow you reach emails from your app |
| `<project_name>_redis-session`  | n/6379  | Allow you save your sessions in Redis |
| `<project_name>_redis`  | n/6379  | Redis cache |

If you want execute ./bin/magento, simply do:
```
./magento <command>
```

During development you can fetch problem with permissions,
for example, when php process write file to your working directory,
and on host machine you can't change that file, to resolve this exec:
```
./permission
```
<sub>this will make sure that your host user id equals user id in container</sub>

Note: If you use OS X - to make XDebug working
exec this command in terminal
```
ifconfig lo0 alias 10.254.254.254
```

### License

MIT © 2018 [Roman Sliusar](https://github.com/underser/)
