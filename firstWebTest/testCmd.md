docker build -t lbbxsxlz/nginx .
docker run -d -p 80 --name firstWeb -v $PWD/html:/var/www/html lbbxsxlz/nginx nginx
curl 127.0.0.1:32786
