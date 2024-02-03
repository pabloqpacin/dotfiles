FROM archlinux
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Syu --noconfirm
RUN pacman -S git neofetch tmux zsh --noconfirm
WORKDIR /root
# CMD echo "supdawg"

# docker build -t arch1:v1 .
# docker run -it --rm --name arch_container arch1 zsh