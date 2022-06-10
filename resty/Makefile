default: run

PORT ?= 7070

build:
	docker build -t resty-auth-firebase .

run: build stop
	docker run -p $(PORT):8080 --name resty-auth-firebase-$(PORT) resty-auth-firebase

stop:
	docker rm --force resty-auth-firebase-$(PORT) || true
