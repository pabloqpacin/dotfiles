
install(){
    docker run -d --name registro1 -p 5000:5000 --restart=always -v registro-imagenes:/var/lib/registry registry:2
}


push(){
    docker build -t user/imagen:v1 .
    docker tag user/imagen:v1 localhost:5000/imagen:v1
    docker push localhost:5000
}

explore(){
    docker exec -it registro1 sh
    ls var/lib/registry/docker/registry/v2/repositories

    sudo su
    ls /var/lib/docker/volumes/registro-imagenes/_data/docker/registry/v2/repositories

    curl localhost:5000/v2/_catalog
    # https://github.com/opencontainers/distribution-spec/blob/v1.0.1/spec.md#api
}

# https://stackoverflow.com/questions/34848422/how-can-i-debug-imagepullbackoff
