default: run

PORT ?= 2016

build:
	docker build -t scallion-caddy .

run: build stop
	docker run -p $(PORT):2016 --name scallion-caddy-$(PORT) scallion-caddy

stop:
	docker rm --force scallion-caddy-$(PORT) || true
