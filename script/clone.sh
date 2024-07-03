#!/usr/bin/env bash

# Set the prompt for the shell
PS1="$"
basedir="$(cd "$1" && pwd -P)"
workdir="$basedir/work"
gpgsign="$(git config commit.gpgsign || echo "false")"

git clone --recursive https://github.com/SpongePowered/Sponge.git
cd Sponge
cp scripts/pre-commit .git/hooks
cd ..
