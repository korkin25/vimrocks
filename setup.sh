#!/bin/sh -eux

dist=$(dirname $0)

sudo apt install vim-nox git

rm -rf ~/.vim ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cp -r ${dist}/.vimrc ~/

vim +PluginInstall +qall
vim +BundleInstall


