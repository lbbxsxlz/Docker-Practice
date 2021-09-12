# netns 测试
查看docker运行容器创建的netns
```
docker inspect firstWeb -f "{{.NetworkSettings.SandboxKey}}"
```
	/var/run/docker/netns/b37fd64b5e2a

创建运行时netns
```
sudo mkdir -p /var/run/netns
sudo ln -s /var/run/docker/netns/b37fd64b5e2a /var/run/netns/firstWeb
```
测试
```
sudo ip netns exec firstWeb ip link show
```

	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	7: eth0@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 


