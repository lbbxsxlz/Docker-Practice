# 创建网络连接
docker network create app-net

# 列举当前docker网络连接
docker network ls

# 查看网络连接的详细信息
docker network inspect $id/$name

# 添加运行的容器添加到网络
docker network connect app-net db2

# 从网络中断开容器
docker network disconnect app-net db2
