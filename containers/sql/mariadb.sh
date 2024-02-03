if ! docker ps -a --format '{{.Names}}' | grep -q "mariadb"; then

    sudo docker run --detach --name mariadb-container \
        --env MYSQL_ROOT_PASSWORD=changeme --env MYSQL_ROOT_HOST='%' \
        --publish 3307:3306 --volume mariadb_data:/var/lib/mysql \
        mariadb:latest

else
    mariadb -h 127.0.0.1 -P 3307 -u root -p

fi

# NOTE: mariadb-client or mysql-client are required
