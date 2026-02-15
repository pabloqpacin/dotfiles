# GitHub Multi-Account Setup

## Setup Inicial

> [!NOTE]
> [YT How to Use Two GitHub Accounts on One Computer](https://www.youtube.com/watch?v=cm68GCEcBXU)


### 1. Check Existing SSH Keys

```sh
ls -la ~/.ssh
```

### 2. Generate ED25519 SSH Keys

```sh
ssh-keygen -t ed25519 -C "pquevedo267@gmail.com"
  # Filename: github_personal

ssh-keygen -t ed25519 -C "pquevedo@setenova.es"
  # Filename: github_setenova
```

### 3. Add SSH Keys to the Agent

```sh
eval "$(ssh-agent -s)"

ssh-add ~/.ssh/github_personal
ssh-add ~/.ssh/github_setenova

# ---

ssh-add -l
```

### 4. Add SSH Keys to GitHub

```sh
cat ~/.ssh/github_personal.pub
cat ~/.ssh/github_setenova.pub
```
```yaml
GitHub Personal:
  Settings:
    SSH and GPG keys:
      - Title: github_personal-PopOS_GL76
        Key: ~/.ssh/github_personal.pub

GitHub Setenova:
  Settings:
    SSH and GPG keys:
      - Title: github_setenova-PopOS_GL76
        Key: ~/.ssh/github_setenova.pub
```

### 5. Configure SSH for Multiple Accounts

```sh
vi ~/.ssh/config
```
```ini
# GitHub Personal
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_personal

# GitHub Setenova
Host github-setenova
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_setenova
```

### 6. Test SSH Connection

```sh
ssh -T git@github-personal
ssh -T git@github-setenova
```

### 7. Use Different Accounts for Different Repositories

```sh
# git@github.com:pabloqpacin/dotfiles.git
git clone git@github-personal:pabloqpacin/dotfiles.git

# git@github.com:pquevedo-stnv/test-setenova-github-multiaccount.git
git clone git@github-setenova:pquevedo-stnv/test-setenova-github-multiaccount.git

# ---

# git@github.com:setenova/INT-IaC_orga.git
git clone git@github-setenova:setenova/INT-IaC_orga.git
```

### 8. Set Git User per Repository

> [!NOTE]
> **Custom**

```sh
cd ~/dotfiles
mkdir .gitconfig.d

git mv .gitconfig .gitconfig.d/.gitconfig
vi .gitconfig.d/setenova.gitconfig

ln -sf ~/dotfiles/.gitconfig.d/.gitconfig ~/.gitconfig
```


<!--
```sh
cd <REPO>

git config user.name "<USERNAME>"
git config user.email "<EMAIL>"
```
```sh
git commit -m "<MESSAGE>"
git push
``` -->


---

## Extras

- [x] DEMO (Ajustes cambios para clonar, push, etc -- cambiar github.com por github-personal o github-setenova...)
- [x] Gestión de `~/.gitconfig`...
- [ ] Cuenta Trabajo: Email Secreto
