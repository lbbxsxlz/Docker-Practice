# docker自带编排工具
docker-compose

# YAML的散列定义
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

# 启动服务
docker-compose up
docker-compose up -d

# 查看服务
docker-compose ps

# 查看服务日志
docker-compose logs

# 停止服务
docker-compose stop

# 删除服务
docker-compose rm

