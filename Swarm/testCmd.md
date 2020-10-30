# Swarm工具

# from <<the docker file>>
## 拉取swarm镜像
docker pull swarm

## 创建docker swarm
docker run --rm swarm create

## 运行swarm容器
docker run -d swarm join --addr=$hostip:$port token://$token

# from <<docker deep dive>>
## 创建新的Swarm
docker swarm init
