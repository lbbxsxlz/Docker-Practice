# web redis 容器连接
## 1、Docker Networking

### 创建docker网络
```
docker network create app-net
```
### 运行redis容器
```
docker run -d --net=app-net(--network app-net) --name db lbbxsxlz/ubuntu_16.04:redis-server
```
redis db容器的构建见上级目录redis中的Dockerfile

### 运行webapp-redis容器
```
docker run -p 4567 --net=app-net(--network app-net) --name webapp-redis -t -i -v $PWD/webapp_redis:/opt/webapp lbbxsxlz/ubuntu_16.04_webapp /bin/bash
```
### 在容器内部运行应用
```
nohup /opt/webapp/bin/webapp &
```
### webapp-redis容器的另一种启动方式
```
docker run -d -p 4567 --net=app-net(--network app-net) --name webapp-redis -v $PWD/webapp_redis:/opt/webapp lbbxsxlz/ubuntu_16.04_webapp
```

### 测试
```
docker port webapp-redis
```
4567/tcp -> 0.0.0.0:32796
#### 向web提交数据 post请求
```
curl -i -H 'Accept: application/json' -d 'name=lbbxsxlz&status=Testing' http://localhost:32796/json
```
HTTP/1.1 200 OK 
Content-Type: text/html;charset=utf-8
Content-Length: 38
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Server: WEBrick/1.3.1 (Ruby/2.3.1/2016-04-26)
Date: Sat, 19 Sep 2020 08:36:37 GMT
Connection: Keep-Alive

{"name":"lbbxsxlz","status":"Testing"}
#### 向web查询数据 get请求

该部分代码详见[here](https://github.com/lbbxsxlz/Docker-Practice/blob/master/Sinatra/webapp_redis/lib/app.rb)

```
curl -i http://localhost:32796/json
```
HTTP/1.1 200 OK 
Content-Type: text/html;charset=utf-8
Content-Length: 50
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Server: WEBrick/1.3.1 (Ruby/2.3.1/2016-04-26)
Date: Sat, 19 Sep 2020 08:36:54 GMT
Connection: Keep-Alive

"[{\"name\":\"lbbxsxlz\",\"status\":\"Testing\"}]"


## 2、Docker链接
### 运行redis容器
```
docker run -d --name redis lbbxsxlz/ubuntu_16.04:redis-server
```

### 运行webapp-link容器
```
docker run -p 4567 --name webapp-link --link redis:db -t -i -v $PWD/webapp_redis:/opt/webapp lbbxsxlz/ubuntu_16.04_webapp /bin/bash
```

### 在容器内部运行应用
```
nohup /opt/webapp/bin/webapp &
```

### webapp-redis容器的另一种启动方式
```
docker run -d -p 4567 --name webapp-link --link redis:db -v $PWD/webapp_redis:/opt/webapp lbbxsxlz/ubuntu_16.04_webapp
```

### 测试
测试方式与上文一致，唯一区别的端口
