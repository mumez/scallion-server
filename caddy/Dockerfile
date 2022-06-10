FROM caddy:2.5.1-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-webdav \
    --with github.com/ggicci/caddy-jwt@v0.7.1

FROM caddy:2.5.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

VOLUME [ "/uploads" "/conf" "/data" "/html" ]

# --------------------
# Locale
# --------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apk add tzdata
ENV TZ=Asia/Tokyo
RUN date

CMD ["caddy", "run", "--config", "/conf/Caddyfile", "--adapter", "caddyfile"]
