
build_image(){

    # Tweak according with the directory structure
    cd $HOME/dotfiles/containers/linux/archlinux
    if [ $? != 0 ]; then echo "There was an error. Terminating script"; exit 1; fi

    docker build -t pabloqpacin/archlinux:vN .
}

# TODO: ensure the paths are ok

push_image(){

    docker login
    docker push pabloqpacin/archlinux:v1
    # docker tag
    # docker scout
    # docker commit
}

run_container(){
    docker run -it --name arch1 \
        # -v archlinux-data:/data \
        pabloqpacin/archlinux:latest        # 'zsh' command .. no need because of ENTRYPOINT in Dockerfile...
}

connect(){
    docker start -i arch1
    # docker exec -it
}


