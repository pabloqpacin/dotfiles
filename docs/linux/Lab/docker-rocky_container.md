
- [epel](https://www.redhat.com/en/blog/whats-epel-and-how-do-i-use-it)

```bash
docker volume ls
docker volume inspect rocky_data && docker volume rm rocky_data

docker run -it --name rockycontainer -v rocky_data:/data rockylinux:9 bash
    # exit
docker start rockycontainer

docker exec --it rockycontainer bash
    # dnf upgrade --refresh -y 
    # dnf update -y
    # dnf list --installed | wc -l      # 151
    #
    # dnf install epel-release -y
    # dnf install --setopt=install_weak_deps=False neofetch

docker exec -it --workdir=/root rockycontainer zsh
```

