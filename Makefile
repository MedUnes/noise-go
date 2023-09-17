include ./.env

service=go-noise
compose	=	docker compose
compose_exec	 =	$(compose) exec --user=1000:1000 $(service) 'bash'
build:
	$(compose) up --build -d
down:
	$(compose) down --volumes --remove-orphans
	$(compose) down --volumes --remove-orphans
status:
	$(compose) ps
up:
	$(compose) up -d
stop:
	$(compose) stop
restart:
	$(compose) restart $(service)
login:
	$(compose_exec)
logs:
	$(compose) logs -f

gbuild:
	$(compose_exec) '-c' 'go build -ldflags="-s -w" -o bin/noise'
b:
	go build -ldflags="-s -w" -o bin/noise
run:
	$(compose_exec) '-c' 'go run main.go'
r:
	go run main.go
