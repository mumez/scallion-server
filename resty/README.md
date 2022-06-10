# resty-auth-firebase

Firebase JWT authentication running on OpenResty

# Installation (Mac)

## OpenResty

```
brew install homebrew/nginx/openresty
```

## Lua (5.1)

```
brew install lua@5.1
```

## Packages

```
opm install jkeys089/lua-resty-hmac
opm install thibaultcha/lua-resty-jit-uuid
opm install cdbattags/lua-resty-jwt
opm install openresty/lua-resty-string
opm install pintsized/lua-resty-http
```

## Start

```
openresty -p `pwd` -c conf/nginx.conf
```

## Stop

```
openresty -s stop
```

## Reload

```
openresty -s reload
```

