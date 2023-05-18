
# Docker to PHP 8.1, Apache and PHP sqlsrv driver. (Ubuntu 20.04 LTS)

This is a initial schema for Docker with Ubuntu 20.04 LTS based (AMD64).

Softwares Installed:
- PHP 8.1
- Apache 2.4
- msodbcsql17 and mssql-tools 
- sqlsrv and pdo_sqlsrv PHP driver
- mysql PHP driver






## Environment variables

To run this project, you will need to add the following environment variables to your .env

`MYSQL_ROOT_PASSWORD`



## Install


```bash
  docker-compose build
  docker-compose up -d
  docker-compose up --build -d
  docker exec -t container-name bash -c "composer update"
  docker exec -t container-name bash -c "php artisan key:generate"

  composer create-project --prefer-dist laravel/laravel blog

  composer update --ignore-platform-reqs

  cat /var/log/apache2/error.log

  cat /etc/hosts

  cat /etc/os-release

  # 37.148.213.228


  bash ~/Dropbox/Helper/docker-clean.sh && docker-compose -f docker-ubuntu20.4-apache-php8.2-mysql-sqlsrv-mac/docker-compose.yml up -d --build apache

  bash ~/Dropbox/Helper/docker-clean.sh && docker-compose -f docker-compose-laravel/docker-compose.yml up -d --build app

  docker build -t test .
  docker run -d -p 80:80 test


  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache-php8-sqlsrv


  docker exec -it apache-php8-sqlsrv bash
  docker exec -t apache-php8-sqlsrv bash -c "php -m"

  docker exec -t apache-php8-sqlsrv bash -c "composer update"

  docker exec -t apache-php8-sqlsrv bash -c "php artisan key:generate"
  docker exec -t apache-php8-sqlsrv bash -c "php artisan optimize:clear”
  docker exec -t apache-php8-sqlsrv bash -c "php artisan migrate:fresh —seed"

```
    
## Etiquetas


[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)



