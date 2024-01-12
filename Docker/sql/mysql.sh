if ! docker ps -a --format '{{.Names}}' | grep -q "mysql-container"; then
    
    # docker volume inspect mysql_data && docker volume rm mysql_data

    sudo docker run --detach --name mysql-container \
        --env MYSQL_ROOT_PASSWORD=changeme --env MYSQL_ROOT_HOST='%' \
        --publish 3306:3306 --volume mysql_data:/var/lib/mysql \
        mysql
        # --env MYSQL_PAGER="less -SFXR" \

else

    # docker start mysql-container
    
    mycli -h 127.0.0.1 -P 3306 -u root -p || \
    mysql -h 127.0.0.1 -P 3306 -u root -p

fi

# NOTE: mycli or mariadb-client or mysql-client required
