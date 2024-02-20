FROM archlinux
# TODO: FROM archlinux:foo

WORKDIR /root

RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Syu --noconfirm

RUN pacman -S git neofetch tmux zsh --noconfirm
RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles
RUN bash ~/dotfiles/scripts/setup/omz-msg_random_theme.sh
RUN rm ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/
RUN bash ~/dotfiles/zsh/plugins/clone-em.sh

ENTRYPOINT [ "/usr/sbin/zsh" ]
