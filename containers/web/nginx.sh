if ! docker ps -a --format '{{.Names}}' | grep -q "nginx"; then

    sudo docker run -d --name nginx1 -p 8080:80 -v ~/web:/usr/share/nginx/html nginx

else
    
    curl localhost:8080 && xdg-open http://localhost:8080

fi

# > https://www.youtube.com/watch?v=2QZrU7vPAjQ
