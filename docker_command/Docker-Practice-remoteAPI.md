# docker remote API

## 修改docker守护进程的启动参数
sudo vim /lib/systemd/system/docker.service  

修改ExecStart字段，例如
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4567 --containerd=/run/containerd/containerd.sock

## 重新启动服务
systemctl daemon-reload
sudo service docker restart

## 测试
curl http://localhost:4567/version
docker -H lbbxsxlz-XPS-8930:4567 info
docker -H lbbxsxlz-XPS-8930:4567 version
curl http://lbbxsxlz-XPS-8930:4567/version

## 查看镜像
curl http://lbbxsxlz-XPS-8930:4567/images/json | python -m json.tool

## 查询docker hub上的镜像
curl http://lbbxsxlz-XPS-8930:4567/images/search?term=lbbxsxlz | python -m json.tool 

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   285  100   285    0     0     66      0  0:00:04  0:00:04 --:--:--    69
[
    {
        "description": "ubuntu 16.04 with nginx",
        "is_automated": false,
        "is_official": false,
        "name": "lbbxsxlz/ubuntu_16.04",
        "star_count": 0
    },
    {
        "description": "with  nginx  ruby redis gem sinatra json ",
        "is_automated": false,
        "is_official": false,
        "name": "lbbxsxlz/ubuntu_16.04_webapp",
        "star_count": 0
    }
]

## 查看所有的容器
curl http://lbbxsxlz-XPS-8930:4567/containers/json?all=1 | python -m json.tool

