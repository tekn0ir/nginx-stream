#!/usr/bin/env bash

# HUP is the way to do a graceful reload in nginx
kill -s HUP `cat /opt/nginx/logs/nginx.pid`