

Absolutely, your line of thinking is on the right track. Running `docker run` to create the container, set up the volume, and perform initial configurations is a good practice. Then, once the initial setup is done, you can use `docker start` and `docker exec` to interact with the container without stopping it.

Here's an example workflow:

```bash
# # Create a named volume
# docker volume create myarchdata

# REMOVE DEPRECATED BS IF EXISTS
docker volume rm myarchdata

# Run the container to perform the initial setup
docker run -it --name myarchcontainer -v myarchdata:/data archlinux bash

# Inside the container, perform installations, configurations, etc.
# For example:
# pacman -Syu
# pacman -S some-package
# ...

# Exit the container

# Start the container in the background (detached mode)
docker start myarchcontainer

# You can now use docker exec to interact with the running container
docker exec --it myarchcontainer bash -c "pacman-key --init && pacman-key --populate archlinux && pacman -Syu --noconfirm"
# docker exec -it --workdir=/root myarchcontainer bash
#     # neofetch, zsh, dotfiles
docker exec -it myarchcontainer bash -c '
    pacman -S git neofetch tmux zsh --noconfirm &&
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles &&
    rm ~/.zshrc && ln -s ~/dotfiles/.zshrc ~
'
docker exec -it --workdir=/root myarchcontainer zsh

# Perform additional actions inside the running container

# Exit the interactive session

# If you need to stop the container later
docker stop myarchcontainer
```

This approach allows you to separate the initial setup from the ongoing usage of the container. It's particularly useful when you want to maintain a long-running container with specific configurations. Using `docker start` and `docker exec` after the initial setup allows you to interact with the container without starting the whole process again.

Remember to replace `some-package` in the example with the actual packages or configurations you need for your use case.

## Run

```bash
lsblk               # host info
pacman -Q | wc -l   # 114
cat /etc/passwd     # http ftp ...

# pacman -Syu         # 'ERROR: There is no secret key available to sign with'
pacman-key --init
pacman-key --populate archlinux
pacman -Syu

pacman -S neofetch && neofetch

exit
```

## Exec

```bash
docker start myarchcontainer

docker exec -it myarchcontainer bash
```

```bash
pacman -S git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


```


``` bash
docker exec -it --workdir=/root myarchcontainer zsh

```

---

## Apasoft

```bash
docker start -i ubuntu1
```