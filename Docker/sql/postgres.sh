if ! docker ps -a --format '{{.Names}}' | grep -q "postgres-container"; then

    # sudo docker run --detach --name postgres-container \
    #     --env POSTGRES_USER=myuser --env POSTGRES_PASSWORD=mypassword \
    #     --publish 5432:5432 --volume postgres_data:/var/lib/postgresql/data \
    #     postgres

    sudo docker run -d --name postgres-container \
        -e POSTGRES_PASSWORD=changeme -p 5432:5432 \
        -v postgres_data:/var/lib/postgresql/data \
        postgres

else

    pgcli postgresql://postgres:changeme@localhost:5432 || \
    pgcli -h localhost -p 5432 -U postgres -W || \
    # psql ... || \
    # sudo docker exec

fi

# NOTE: mycli or mariadb-client or mysql-client required




# https://hub.docker.com/_/postgres/
# $ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
# $ docker run -it --rm --network some-network postgres psql -h some-postgres -U postgres

