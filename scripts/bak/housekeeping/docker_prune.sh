#!/bin/bash

docker volume prune
docker network prune
# docker image prune

for volume in $(docker volume ls --format '{{.Name}}'); do
    docker volume rm "${volume}"
done

for container in $(docker ps -a --format '{{.Names}}'); do
    docker rm "${container}"
done


# buildx cache?

# ---
# custom zsh docker plugin
# docker-prune () {
#         yes | grc docker network prune && yes | grc docker volume prune && yes | grc docker image prune && yes | grc docker builder prune
# }
