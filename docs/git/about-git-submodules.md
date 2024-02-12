# Git Submodules

> https://git-scm.com/book/en/v2/Git-Tools-Submodules

## Base file structure

```bash
mkdir -p ~/Setesur/OPS/Windows
```

## Submodule repo

```bash
cd ~/Setesur/OPS/Windows

git init 
git add .
git commit -m "Initial commit for setesur-win"

# Github.com: public repo: setesur-win

git remote add origin git@github.com:pabloqpacin/setesur-win.git
git push -u origin main
```


## Main repo


```bash
cd ~/Setesur

git init

# Github.com: private repo: Setesur
git remote add origin git@github.com:pabloqpacin/Setesur.git

# rm -rf ~/Setesur/OPS/Windows
git submodule add git@github.com:pabloqpacin/setesur-win.git OPS/Windows

git add .
git commit -m "Initial commit for Setesur; add setesur-win as submodule"

git push -u origin main
```


## Mantener

- Si se hacen cambios en el submodule, después de los pushear las nuevas commits, hacer esto en el repo principal

```bash
#        modified:   OPS/Windows (untracked content)
#        modified:   OPS/Windows (new commits)

git submodule update --remote --recursive
```

---

## Beyond

```bash
# When others clone the "Setesur" repository, they might need to initialize and update the submodule. Consider advising them to use the --recurse-submodules option:
git clone --recurse-submodules git@github.com:pabloqpacin/Setesur.git
```
```bash
cd repo
git pull
git submodule update --init --recursive
```

---

# [makigas](https://www.youtube.com/watch?v=YVUkxt3Bvwg)


## clonar

- Clonar el repo con submódulos

```bash
# Clonar repo principal
git clone <repo>
cd <repo>

# Clonar submódulos
git submodule init          # Submodule 'foo' (url) registered for path 'foo'
git submodule update        # Cloning into...
```

## actualizar

- ...

```bash
git diff --submodule
```

- Forma 1

```bash
cd ~/repo/
git submodule

cd ~/repo/modulo
# git branch -a
# git fetch &&
git pull

cd ~/repo
git diff
git submodule
# git add     # ??
git commit -m "Update submodule"
```

- Forma 2

```bash
cd ~/repo/modulo
git fetch
git diff main...origin/main
git merge origin/main
```

- Forma 3

```bash
cd ~/repo
git submodule update --remote --recursive
git status
git diff
```

- Forma 4

```bash
git pull --recurse-submodules
```