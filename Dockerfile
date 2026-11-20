FROM debian:13-slim
MAINTAINER Anders Åslund <anders.aslund@teknoir.se>

WORKDIR /opt

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget libpcre2-dev build-essential libssl-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://nginx.org/download/nginx-1.30.7.tar.gz && \
    tar -zxvf nginx-1.*.tar.gz && \
    cd nginx-1.* && \
    ./configure --prefix=/opt/nginx --user=nginx --group=nginx --with-http_ssl_module --with-ipv6 --with-threads --with-stream --with-stream_ssl_module && \
    make && \
    make install && \
    cd .. && \
    rm -rf nginx-1.* && \
    apt-get purge -y wget libpcre2-dev build-essential libssl-dev zlib1g-dev

# nginx user
RUN groupadd nginx && \
    useradd --system --no-create-home --shell /usr/sbin/nologin --password="" -g nginx nginx

# config dirs
RUN mkdir /opt/nginx/http.conf.d /opt/nginx/stream.conf.d

ADD nginx.conf /opt/nginx/conf/nginx.conf
ADD zero_downtime_reload.sh /opt/nginx/sbin/zero_downtime_reload.sh

WORKDIR /

EXPOSE 80 443

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
