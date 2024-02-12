if ! docker ps -a --format '{{.Names}}' | grep -q "mariadb"; then

    sudo docker run --detach --name mariadb-container \
        --env MYSQL_ROOT_PASSWORD=changeme --env MYSQL_ROOT_HOST='%' \
        --publish 3307:3306 --volume mariadb_data:/var/lib/mysql \
        mariadb:latest

    docker run -d --name mariadb2 -p 3307:3306 \
        -e MYSQL_ROOT_PASSWORD=changeme - MYSQL_ROOT_HOST='%' \
        -v mariadb2/var/lib/mysql \
        mariadb:latest

else
    mycli -h localhost -P 3307 -u root -p

fi

# NOTE: mycli or mariadb-client or mysql-client are required
