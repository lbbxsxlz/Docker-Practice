FROM ubuntu_16.04
LABEL maintainer="lbbxsxlz@gmail.com"
ENV REFRESHED_AT 2021-02-27
RUN apt-get update
RUN apt-get -y install gcc
RUN apt-get -y install vim-tiny
RUN mkdir -p /opt/project
VOLUME /opt/project/
WORKDIR /opt/project/
CMD ["/bin/bash"]
