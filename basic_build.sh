#! /bin/bash

build() {
  #创建相关文件夹
  sudo mkdir -p /dockerMaps/data \
    /dockerMaps/conf \
    /dockerMaps/logs
  #mysql5.7.21
  sudo mkdir -p /dockerMaps/data/mysql5.7.21 \
    /dockerMaps/conf/mysql5.7.21/conf.d \
    /dockerMaps/logs/mysql5.7.21
  #redis3.2.12
  sudo mkdir -p /dockerMaps/data/redis3.2.12
  #nginx1.15.12
  sudo mkdir -p /dockerMaps/conf/nginx1.15.12/conf.d \
    /dockerMaps/logs/nginx1.15.12
  #php7.2
  sudo mkdir -p /dockerMaps/conf/php7.2-fpm \
    /dockerMaps/logs/php7.2-fpm
  #rabbitMQ
  sudo mkdir -p /dockerMaps/data/rabbitmq-3.7-management
  #webroot:golang && php && html
  sudo mkdir -p /webroot/go \
    /webroot/php \
    /webroot/html
  #other
  sudo mkdir -p /dockerMaps/other
  #tool
  sudo mkdir -p /dockerMaps/tool
  #复制tool目下的所有文件
  sudo cp -r ./tool/. /dockerMaps/tool
  #复制mysql conf.d文件夹下文件
  sudo cp -r ./basic/conf/mysql5.7.21/conf.d/. /dockerMaps/conf/mysql5.7.21/conf.d
  #复制nginx.conf文件
  sudo cp ./basic/conf/nginx1.15.12/nginx.conf /dockerMaps/conf/nginx1.15.12/nginx.conf
  sudo cp -r ./basic/conf/nginx1.15.12/conf.d/. /dockerMaps/conf/nginx1.15.12/conf.d
  #复制php7.2配置文件
  sudo cp -r ./php7.2-fpm/conf/. /dockerMaps/conf/php7.2-fpm
  # create docker network
  sudo docker network create custom
}

build
echo "done!"
