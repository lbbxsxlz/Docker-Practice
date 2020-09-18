## 构建镜像
```
docker build -t lbbxsxlz/ubuntu_16.04_webapp .
```
Sending build context to Docker daemon   5.12kB
Step 1/8 : FROM ubuntu:16.04
 ---> 4b22027ede29
Step 2/8 : LABEL maintainer="lbbxsxlz@gmail.com"
 ---> Using cache
 ---> a9ae81abbb3f
Step 3/8 : ENV REFRESHED_AT 2020-09-18
 ---> Running in 7fc75955ecff
Removing intermediate container 7fc75955ecff
 ---> 72c1adff7631
Step 4/8 : RUN apt-get -qq update && apt-get -qq install ruby ruby-dev build-essential redis-tools
 ---> Running in d1bcb6afe5ec
......
Step 5/8 : RUN gem install --no-rdoc --no-ri sinatra json redis
 ---> Running in 51b83ff93a8b
Successfully installed rack-2.2.3
Successfully installed tilt-2.0.10
Successfully installed rack-protection-2.1.0
Successfully installed ruby2_keywords-0.0.2
Successfully installed mustermann-1.1.1
Successfully installed sinatra-2.1.0
Building native extensions.  This could take a while...
Successfully installed json-2.3.1
Successfully installed redis-4.2.2
8 gems installed
Removing intermediate container 51b83ff93a8b
 ---> cb7d359d003f
Step 6/8 : RUN mkdir -p /opt/webapp
 ---> Running in 58eb5360f64f
Removing intermediate container 58eb5360f64f
 ---> 302d582fe9ee
Step 7/8 : EXPOSE 4567
 ---> Running in 1e99c98b6c51
Removing intermediate container 1e99c98b6c51
 ---> dd668ee3abcf
Step 8/8 : CMD [ "/opt/webapp/bin/webapp" ]
 ---> Running in 563acb3a1f63
Removing intermediate container 563acb3a1f63
 ---> 339c223457b1
Successfully built 339c223457b1
Successfully tagged lbbxsxlz/ubuntu_16.04_webapp:latest

## 运行容器
```
docker run -d -p 4567 --name webapp -v $PWD/webapp:/opt/webapp lbbxsxlz/ubuntu_16.04_webapp 
```

## 容器运行测试
```
docker ps -l
```
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                     NAMES
e4423b775bd6        lbbxsxlz/ubuntu_16.04_webapp   "/opt/webapp/bin/web…"   5 seconds ago       Up 5 seconds        0.0.0.0:32789->4567/tcp   webapp
```
dockerer top webapp
```
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                16183               16165               0                   16:33               ?                   00:00:00            /usr/bin/ruby /opt/webapp/bin/webapp

```
docker logs webapp
```
[2020-09-18 08:33:55] INFO  WEBrick 1.3.1
[2020-09-18 08:33:55] INFO  ruby 2.3.1 (2016-04-26) [x86_64-linux-gnu]
== Sinatra (v2.1.0) has taken the stage on 4567 for development with backup from WEBrick
[2020-09-18 08:33:55] INFO  WEBrick::HTTPServer#start: pid=1 port=4567
```
curl -i -H 'Accept: application/json' -d 'name=lbbxsxlz&status=Testing' http://localhost:32789/json
```
HTTP/1.1 200 OK 
Content-Type: text/html;charset=utf-8
Content-Length: 38
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Server: WEBrick/1.3.1 (Ruby/2.3.1/2016-04-26)
Date: Fri, 18 Sep 2020 08:39:23 GMT
Connection: Keep-Alive

{"name":"lbbxsxlz","status":"Testing"}

