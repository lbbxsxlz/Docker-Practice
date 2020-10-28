# docker自带编排工具
docker-compose

## 安装
sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

## 验证是否成功安装
docker-compose --version
docker-compose version 1.27.4, build 40524192

## YAML的散列定义
version: '3'
services:
  web:
    image: jamtur01/composeapp
    command: python app.py
    ports:
     - "5000:5000"
    volumes:
     - .:/composeapp
  redis:
    image: redis

## 启动服务
docker-compose up
docker-compose up -d

## 查看服务
docker-compose ps

## 查看服务日志
docker-compose logs

## 停止服务，仅停止容器
docker-compose stop

## 删除服务，删除容器与网络
docker-compose rm

## 停止服务，删除容器、网络，留下镜像、卷、源码
docker-compose down

## 查找卷的挂载点
docker volume inspect docker-compose_counter-vol | grep Mount
"Mountpoint": "/var/lib/docker/volumes/docker-compose_counter-vol/_data",

## 删除服务创建的卷
docker volume rm docker-compose_counter-vol

