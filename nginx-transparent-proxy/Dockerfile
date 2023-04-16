################################################################
# BUILDER
#
# Compile ngx_http_proxy_connect_module source
################################################################

ARG NGINX_VERSION=1.23.2

FROM nginx:${NGINX_VERSION}-alpine AS builder

ARG NGINX_VERSION

ENV BUILD_DIR /usr/share/tmp

ENV CONNECT_VERSION 0.0.4
ENV CONNECT_PATCH_VERSION proxy_connect_rewrite_102101

WORKDIR $BUILD_DIR

RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre2-dev \
  zlib-dev \
  linux-headers \
  openssl \
  alpine-sdk \
  findutils \
  netcat-openbsd

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar zxf nginx-${NGINX_VERSION}.tar.gz \
  && rm nginx-${NGINX_VERSION}.tar.gz

RUN wget -O ngx_http_proxy_connect_module.tar.gz https://github.com/chobits/ngx_http_proxy_connect_module/archive/v${CONNECT_VERSION}.tar.gz \
  && tar -xzvf ngx_http_proxy_connect_module.tar.gz

RUN cd nginx-${NGINX_VERSION} \
  && patch -p1 < $BUILD_DIR/ngx_http_proxy_connect_module-${CONNECT_VERSION}/patch/${CONNECT_PATCH_VERSION}.patch  \
  && CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
  && CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} \
  && ./configure \
      $CONFARGS \
      --add-module=${BUILD_DIR}/ngx_http_proxy_connect_module-${CONNECT_VERSION} \
  && make \
  && make install

RUN mkdir /usr/local/certs \
  && cd /usr/local/certs \
  && openssl req -x509 -nodes -days 365 -subj "/CN=proxy.sjdonado.de" \
  -newkey rsa:2048 -keyout proxy.key -out proxy.crt;

################################################################
# SERVER
#
# Proxy forward / SSL transparent tunnel
################################################################

FROM builder

EXPOSE 3128

COPY ./default.nginx.conf /etc/nginx/conf.d/default.conf
COPY ./scripts/download-cert.sh /usr/bin/download-cert

CMD ["nginx", "-g", "daemon off;"]
