## 使用镜像

 - alpine:latest
 - nginx:1.5.12
 - mysql:5.7.21
 - redis:3.2.12
 - php:7.2-fpm


## 目录

```
clDocker
│  basic_build.sh
│  Readme.md
│
├─basic ## mysql、nginx、redis
│  │  docker-compose.yml
│  │
│  └─conf
│      ├─mysql5.7.21
│      │  └─conf.d
│      │          mysql-file.cnf
│      │
│      └─nginx1.15.12
│          │  nginx.conf
│          │
│          └─conf.d
│                  default.conf
│
├─golang
│  │  Dockerfile ## go-alpine
│  │
│  └─apiserver ## 示例应用
│          docker-compose.yml
│
├─php7.2-fpm
│  │  docker-compose.yml
│  │  Dockerfile
│  │
│  ├─conf
│  │      php.ini
│  │
│  └─pkg
│          redis.tgz ## pcel:redis扩展
│
└─tool
        wait-for ## alpine(sh)可用等待其他服务
```


## Usage
```
## 创建容器映射目录及容器连接网络custom；
## 复制tool目录下文件（部分容器使用）；
## 复制mysql conf.d文件夹。
## 复制nginx.conf（否则nginx挂载时空文件会覆盖容器中文件,其他容器同理）。
## 复制php7.2-fpm配置文件。
sudo chmod +x ./basic_build.sh
./basic_build.sh

## 创建mysql、redis、nginx容器。
## 容器连接网络为custom，容器间通过服务名可互相访问。
cd basic
sudo docker-compose up -d

## 示例golang apiserver应用
## golang 交叉编译linux:
## CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o apiserver .
## 上传apiserver二进制文件至/webroot/go/apiserver/
## sudo chmod +x /webroot/go/apiserver/apiserver
## 上传conf.yaml至/webroot/go/apiserver/conf
#  conf.yaml通过服务名连接mysql,redis容器。
## wait-for为alpine(sh)可用等待其他服务;等待mysql、redis先启动。
## golang/Dockerfile 构建镜像alpine并安装tzdata、openssl、ca-certificates。
cd golang
sudo docker-compose up -d

## 创建php7.2-fpm容器，镜像包含composer
cd php-7.2-fpm
sudo docker-compose up -d

## 示例php应用
## 上传应用至宿主机/webroot/php
```

## Nginx server配置
```
## golang proxy_pass 地址可填写为服务器名
server {
    listen      80;
    server_name  localhost;
    client_max_body_size 1024M;

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass  http://apiserver:8001/;
        client_max_body_size 5m;
    }
}
```

```
## php 此处$document_root不再是root中配置目录，应为php-fpm容器内应用所在目录
server {
    listen       80;
    server_name  localhost;
    root   /webroot/php/latest/public;
    index  index.html  index.php;
    location / {
        try_files $uri $uri/
        /index.php$is_args$query_string;
    }
    location ~ \.php(.*)$ {
        fastcgi_pass   php-fpm:9000;
        fastcgi_index  index.php;
        fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
        fastcgi_param  SCRIPT_FILENAME  /data/www/latest/public/$fastcgi_script_name;
        fastcgi_param  PATH_INFO  $fastcgi_path_info;
        fastcgi_param  PATH_TRANSLATED  /data/www/latest/public/$fastcgi_path_info;
        include        fastcgi_params;
    }
}
```

## Download
wait-for：[https://github.com/eficode/wait-for](https://github.com/eficode/wait-for)

PHP extension for interfacing with Redis-4.1.0：[https://pecl.php.net/package/redis/4.1.0](https://pecl.php.net/package/redis/4.1.0)