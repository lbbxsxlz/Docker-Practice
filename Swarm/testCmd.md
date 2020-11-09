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

