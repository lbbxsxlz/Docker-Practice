# Swarm工具

# from <<the docker file>>
## 拉取swarm镜像
docker pull swarm

## 创建docker swarm
docker run --rm swarm create

“
2020/11/09 08:40:53 Post https://discovery.hub.docker.com/v1/clusters: dial tcp: lookup discovery.hub.docker.com on 8.8.8.8:53: no such host
”
## 运行swarm容器
docker run -d swarm join --addr=$hostip:$port token://$token

目前测试失败，未解决


# from <<docker deep dive>>
## 创建新的Swarm
docker swarm init --advertise-addr $ip:$port --listen-addr $ip:$port

## 列出swarm 节点
docker node ls

## 获取工作节点
docker swarm join-token worker

## 获取管理节点
docker swarm join-token manager


P.S. 以上操作均在管理节点上操作，以下操作在工作节点操作

## 加入工作节点
docker swarm join --token $token $managerIp:port --advertise-addr $localhostip:port --listen-addr $localhostip:port

## 启用锁
docker swarm init --autolock
docker swarm update --autolock=true

## 解锁swarm
docker swarm unlock

# 服务
## 创建服务
docker service create --name $name -p 8080:8080 --replicas 5 $dockeImagesName
部署全局服务，添加以下参数，默认是副本模式
--mode global 

## 查看swarm运行的服务 
docker service ls

## 查看服务副本与状态
docker service ps $name

## 查看服务的详细信息
docker service inspect --pretty $name

## 服务扩容与缩容
docker service scale $name=$num

## 删除服务
docker service rm $name

# 服务升级demo
docker network create -d overlay uber-net

docker service create --name uber-svc --network uber-net -p 80:80 --replicas 12 demo:v1

docker service create --name uber-svc --network uber-net --publish published=80,target=80,mode=host --replicas 12 demo:v1  #主机模式

docker service update --image demo:v2 --update-parallelism 2 --update-delay 20s uber-svc

## 服务日志
docker service logs

