FROM ubuntu:16.04
LABEL maintainer="lbbxsxlz@gmail.com"
#ENV REFRESHED_AT 2020-09-14
RUN apt-get update
RUN apt-get -y install nginx
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index_org.html
RUN echo 'Hello, i am in your first container' > /usr/share/nginx/html/index.html
EXPOSE 80
#ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
ENTRYPOINT ["/usr/sbin/nginx"]

