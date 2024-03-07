# https://docs.portainer.io/start/install-ce/server/docker/linux

install_portainer(){
    if ! docker ps -a --format '{{.Names}}' | grep -q "portainer"; then
        docker run -d --name portainer --restart=always -p 8000:8000 -p 9443:9443  \
            -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data \
            portainer/portainer-ce:latest
    fi
}

init(){
    curl localhost:9443
    xdg-open http://localhost:9443
    # poblema con el SSL cert
    # email & password == admin & passwordbymanager
}

# install_portainer
# init