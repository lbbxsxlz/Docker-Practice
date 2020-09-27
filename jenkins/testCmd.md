## 构建镜像
docker build -t lbbxsxlz/jenkins .

## 启动容器
docker run -p 8080:8080 --name jenkins --privileged -d lbbxsxlz/jenkins

## 查看jenkins默认密码
docker exec -it jenkins /bin/bash

## cat /var/jenkins_home/secrets/initialAdminPassword
