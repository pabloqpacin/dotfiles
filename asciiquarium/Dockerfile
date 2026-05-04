# trunk-ignore-all(checkov/CKV_DOCKER_2)
# trunk-ignore-all(checkov/CKV_DOCKER_7)
# trunk-ignore-all(hadolint/DL3007)

FROM archlinux:latest

RUN pacman-key --init \
  && pacman-key --populate archlinux \
  && pacman -Syu --noconfirm \
  && pacman -S --noconfirm base-devel git core/sudo go

RUN useradd -m builder \
  && echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder


USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/yay.git
WORKDIR /home/builder/yay

RUN makepkg -si --noconfirm \
  && yay -S --noconfirm asciiquarium-transparent-git


ENTRYPOINT [ "asciiquarium", "-t", "-s" ]

