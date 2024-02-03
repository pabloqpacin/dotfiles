if ! docker ps -a --format '{{.Names}}' | grep -q "nginx"; then

    sudo docker run --detach --name nginx-container --publish 8080:80 nginx

else
    
    curl localhost:8080 && xdg-open http://localhost:8080

fi

