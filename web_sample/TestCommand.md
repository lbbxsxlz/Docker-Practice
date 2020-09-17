docker build -t lbbxsxlz/ubuntu_16.04_nginx .
docker run -d -p 80 --name Sample -v $PWD/web_sample/html:/var/www/html/website lbbxsxlz/ubuntu_16.04_nginx nginx
curl 127.0.0.1:32783
