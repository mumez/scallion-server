# Dockerfile - ALLSTOCKER
# ref. https://github.com/sorabito/allstocker-resty-auth

FROM openresty/openresty:xenial

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/

RUN opm install jkeys089/lua-resty-hmac
RUN opm install thibaultcha/lua-resty-jit-uuid
RUN opm install cdbattags/lua-resty-jwt
RUN opm install openresty/lua-resty-string
RUN opm install pintsized/lua-resty-http

ENV OPENRESTY_HOME /usr/local/openresty
ENV NGINX_HOME $OPENRESTY_HOME/nginx

COPY conf $NGINX_HOME/conf
COPY logs $NGINX_HOME/logs
COPY lua  $NGINX_HOME/lua

RUN mkdir $NGINX_HOME/cache

VOLUME [ "$NGINX_HOME/conf", "$NGINX_HOME/lua/conf", "$NGINX_HOME/logs" ]

# --------------------
# Locale
# --------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TZ=Asia/Tokyo

RUN echo $TZ > /etc/timezone \
    && apt-get update && apt-get install -y tzdata \
    && rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean

ENTRYPOINT ["/usr/local/openresty/bin/openresty"]
CMD ["-p", "/usr/local/openresty/nginx", "-c", "conf/nginx.conf", "-g", "daemon off;"]
