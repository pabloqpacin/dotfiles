if ! docker ps -a --format '{{.Names}}' | grep -q "mysql-container"; then
    
    # docker volume inspect mysql_data && docker volume rm mysql_data

    sudo docker run --detach --name mysql-container \
        --env MYSQL_ROOT_PASSWORD=changeme --env MYSQL_ROOT_HOST='%' \
        --publish 3306:3306 --volume mysql_data:/var/lib/mysql \
        mysql

else

    # docker start mysql-container
    mysql -h 127.0.0.1 -u root -p

fi

# NOTE: mariadb-client or mysql-client are required
