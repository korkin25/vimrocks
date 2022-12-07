#!/bin/sh 

rm -rf ~/.vim ~/.vimrc

dist=$(dirname $0)

sudo apt -y install vim-nox git links2 yamllint

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cp -r ${dist}/.vimrc ~/

vim +PluginInstall +qall
vim +BundleInstall +qall

git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"

echo Folding helm
links2 -dump http://vimcasts.org/episodes/how-to-fold/ | egrep '(^[[:space:]]+z.+$|\:help)'

#yamllint staff
mkdir -p ~/.config/yamllint
cat << END > ~/.config/yamllint/config
extends: relaxed

rules:
  line-length: disable
END

