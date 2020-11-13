# NGINX Blackhole
A small hachathon project to play with using [openresty's lua nginx module](https://github.com/openresty/lua-nginx-module) in order to throw away request at the nginx level.

## How it works
This uses docker-compose to stand up 2 containers, one nginx container and another downsteam sample app container. The
sample app container mostly just echos the endpoint you hit back to you but has another function to create and destroy
blackhole files that are in a shared volume with the nginx container. The nginx container then uses lua to check if
blackhole files exist and it should not hit the downstream and just display its own error page.

## How to use it
To stand up the containers
`docker-compose up`

To blackhole endpoint foo:
```
$ curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"action":"create","uri":["foo"]}' \
  127.0.0.1:3000/blackhole
```

To destroy a blackhole on an endpoint:
```
$ curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"action":"destroy","uri":["foo"]}' \
  127.0.0.1:3000/blackhole
```
