#!/bin/bash

### Installation only works for Ubuntu-based distros -- for Debian, change 'ubuntu' for 'debian' at install_docker()
## TODO: check ports regardin mysql

########### VARIABLES ###########
docker_volumes="${HOME}/Docker_vs"

########### FUNCTIONS ###########

install_docker() {
    if ! command -v docker &>/dev/null; then
        sudo apt-get update && sudo apt-get install ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            # docker compose version; docker --version; docker version; sudo docker run hello-world     # systemctl status docker
            sudo usermod -aG docker "${USER}"
        wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.24.2-amd64.deb
        sudo apt-get update && sudo apt-get install ./docker-desktop-4.24.2-amd64.deb && rm docker-desktop-4.24.2-amd64.deb
            # systemctl --user start docker-desktop || systemctl --user enable docker-desktop 
    fi
}

run_portainer() {
    if command -v docker &>/dev/null; then
        docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
        xdg-open http://localhost:9000  # ADMIN SETUP
    fi
}

# run_mysql() {
#     if ! command -v mysql &>/dev/null; then
#         sudo apt-get update && sudo apt-get install mysql-client
#     fi
#     if command -v docker &>/dev/null; then
#         mkdir -p "${docker_volumes}/asir_mysql"
#         docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=changeme -d -p 3306:3306 -v "${docker_volumes}/asir_mysql:/var/lib/mysql" mysql
#         mysql -h 127.0.0.1 -u root -p
#     fi
# }

# # Linux Nginx MariaDB Php for WordPress
# compose_LEMP4WP() {
# }

########### RUNTIME ###########

mkdir "${docker_volumes}"

read -r -p "Install docker (distro must be Ubuntu-based)? [y/N] " opt
if [[ ${opt} == 'y' || ${opt} == 'Y' ]]; then
    install_docker
fi

read -r -p "Run Portainer container? [y/N] " opt
if [[ ${opt} == 'y' || ${opt} == 'Y' ]]; then
    run_portainer
fi

# read -r -p "Install mysql container? [y/N] " opt
# if [[ ${opt} == 'y' || ${opt} == 'Y' ]]; then
#     run_mysql
# fi

# read -p "Install docker (distro must be Ubuntu-based)? [y/N] " opt
# if [[ $opt == 'y' || $opt == 'Y' ]]; then
#     compose_LEMP4WP
# fi

# -- grafana
