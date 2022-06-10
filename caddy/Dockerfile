FROM caddy:2.5.1-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-webdav \
    --with github.com/ggicci/caddy-jwt@v0.7.1

FROM caddy:2.5.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENV CADDY_HOME /data/caddy
WORKDIR $CADDY_HOME

COPY conf $CADDY_HOME/conf
COPY data $CADDY_HOME/data
COPY html  $CADDY_HOME/html

RUN mkdir $CADDY_HOME/dav

VOLUME [ "$CADDY_HOME/dav" "$CADDY_HOME/conf" "$CADDY_HOME/data" "$CADDY_HOME/html" ]

# --------------------
# Locale
# --------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apk add tzdata
ENV TZ=Asia/Tokyo
RUN date

CMD ["caddy", "run", "--config", "./conf/Caddyfile"]
