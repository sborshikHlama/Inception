NAME = inception

SRCS_DIR = srcs
DOCKER_COMPOSE = docker-compose.yml
PATH_TO_COMPOSE = $(SRCS_DIR)/$(DOCKER_COMPOSE)

all: up

up:
	@mkdir -p /Users/logrus/data/mysql
	@docker-compose -f $(PATH_TO_COMPOSE) up --build -d

down:
	@docker-compose -f $(PATH_TO_COMPOSE) down

clean: down
	@docker system prune -a --volumes -f

fclean: clean
	@rm -rf /Users/logrus/data

re: fclean all

.PHONY: all up down clean fclean re
