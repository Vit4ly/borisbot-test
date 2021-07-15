#!/usr/bin/env sh

set -e

npm run build
cd dist
git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:Vit4ly/borisbot.git master:gh-pages

cd -
# $ ssh-keygen -t ed25519 -C "vit4ly.kiselev@gmail.com"
# ssh-add ~/.ssh/id_borisbot
