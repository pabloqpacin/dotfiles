if ! docker ps -a --format '{{.Names}}' | grep -q "portainer"; then

    sudo docker run -d --name portainer --restart always \
        --publish 9000:9000 --volume /var/run/docker.sock:/var/run/docker.sock \
        portainer/portainer-ce

else

    curl localhost:9000 && xdg-open http://localhost:9000

fi


# NOTE: email & password == admin & passwordbymanager
