#!/bin/sh -eux

cp .vimrc ~/

sudo apt install vim-nox
vim +PluginInstall +qall

