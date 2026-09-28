> https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

´´´sh
# $ ssh-keygen -t ed25519 -C "your_email@example.com"

# $ eval "$(ssh-agent -s)"
$ eval (ssh-agent -c | string replace 'setenv ' 'set -gx ')

# $ ssh-add ~/.ssh/id_ed25519
´´´
