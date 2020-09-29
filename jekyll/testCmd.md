## 构建镜像
.目录下必须存在dockerfile，见jekyll和apache目录
```
docker build -t lbbxsxlz/jekyll .
docker build -t lbbxsxlz/apache .
```

## 构建静态网页
此处我使用了自己在github上的静态博客[地址](https://github.com/lbbxsxlz/lbbxsxlz.github.io)

## 使用容器编译静态网页
```
docker run -v $PWD:/data --name lbbxsxlzBlog lbbxsxlz/jekyll
```
$PWD:/home/lbbxsxlz/gitWorkspace/lbbxsxlz.github.io

## 查看挂载卷
docker inspect -f "{{range.Mounts}}{{.}}{{end}}" lbbxsxlzBlog

## 运行apache容器
docker run -d -P --volumes-from lbbxsxlzBlog lbbxsxlz/apache

## 网页访问测试
curl 0.0.0.0:32803

