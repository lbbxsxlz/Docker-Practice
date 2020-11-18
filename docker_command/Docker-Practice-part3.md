## 创建网络连接
docker network create app-net

## 列举当前docker网络连接
docker network ls

## 查看网络连接的详细信息
docker network inspect $id/$name

## 添加运行的容器添加到网络
docker network connect app-net db2

## 从网络中断开容器
docker network disconnect app-net db2

## 删除网络
docker network rm $name
docker network prune   #删除全部未使用的网络

## linux macvlan驱动网络
docker network create -d macvlan --subnet=10.0.0.0/24 --ip-range= 10.0.0.0/25 --gateway=10.0.0.1 -o parent=eth0.100 macvlan100
docker container run -d --name macvlantest --network macvlan100 ubuntu sleep 1d


