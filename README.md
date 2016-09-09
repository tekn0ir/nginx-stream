# Nginx Stream Dockerfile
Nginx compiled with --with-stream to be able to create proxies or loadbalancers for non http protocols.

This repository contains **Dockerfile** of Nginx Stream

### Base Docker Image

* [debian](https://hub.docker.com/_/debian/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download: `docker pull tekn0ir/nginx-stream`

(alternatively, you can build an image from Dockerfile: 
```bash
$ docker build -t="tekn0ir/nginx-stream" github.com/tekn0ir/nginx-stream
```

### Usage

Start deamon
```bash
$ docker run -d -p 0.0.0.0:80:80 --name nginx tekn0ir/nginx-stream
```

### Configure
Create configuration files in folders example:
```bash
.
|
|-- http.conf.d
|   `-- myhttpservice.conf
|
|-- stream.conf.d
    `-- myotherservice.conf
```

myhttpservice.conf example config:
```conf
upstream myhttpservice {
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}

server {
    listen 80;

    location / {
        proxy_pass http://myapp1;
    }
}
```

myotherservice.conf example config:
```conf
upstream myotherservice {
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}

server {
    listen 65432;
    proxy_pass myotherservice;
}
```
For little more help on stream config:
https://nginx.org/en/docs/stream/ngx_stream_core_module.html

Start deamon with configs
```bash
$ docker run -d -p 80:80 -p 65432:65432 -v `pwd`\http.conf.d:/opt/nginx/http.conf.d  -v `pwd`\stream.conf.d:/opt/nginx/stream.conf.d --name nginx tekn0ir/nginx-stream
```

### Zero downtime reloading of changed configs
If you change settings and need to relaod them on a running container w/o downtime
```bash
$ docker exec -ti nginx bash -c 'zero_downtime_reload.sh'
```