#!/bin/sh -x

rm -rf ~/.vim ~/.vimrc

sudo apt -y install vim-nox git links2 flake8 ansible-lint yamllint shellcheck npm python3-pip universal-ctags
sudo npm install -g htmlhint jsonlint

if [ -x "$(which salt-call)" ]; then
   sudo salt-call pip.install salt-lint 
else
   pip install salt-lint
fi

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat > "${HOME}/.vimrc" << VIMRC
" Vim Options
syntax on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set number!

" Ignore case when searching
set ignorecase
set smartcase

" Highlight search results
set incsearch
set hlsearch

" Vundle Plugin Manager Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Specify the plugins you want to install or activate
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'

" Additional plugins or settings...

call vundle#end()
filetype plugin indent on

" Plugin Settings

" Commentary Plugin
nmap gcc <Plug>CommentaryLine
vmap gc <Plug>Commentary

" Fugitive Plugin
map <leader>gs :Git<CR>

" NERDTree Plugin
map <F3> :NERDTreeToggle<CR>

" vim-airline Plugin
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1

" vim-surround Plugin
map cs <Plug>YSurround
map ds <Plug>YSurround

" Additional settings...

" Path to salt-lint
if filereadable('/opt/saltstack/salt/pypath/bin/salt-lint')
    let g:ale_salt_sls_saltlint_executable = '/opt/saltstack/salt/pypath/bin/salt-lint'
else
    let g:ale_salt_sls_saltlint_executable = 'salt-lint'
endif

" Indentation settings for Python
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Indentation settings for Ansible
autocmd FileType yaml,ansible setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Indentation settings for SaltStack (SLS)
autocmd FileType sls setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Indentation settings for Jinja
autocmd FileType jinja setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Indentation settings for HTML
autocmd FileType html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Indentation settings for Bash
autocmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Indentation settings for YAML
autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

let g:indentLine_enabled = 1

set tags=./tags,tags;$HOME
set foldmethod=syntax  " or set foldmethod=indent
VIMRC

mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

vim +PluginInstall +qall

git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"

echo Folding helm
links2 -dump http://vimcasts.org/episodes/how-to-fold/ | grep -E '(^[[:space:]]+z.+$|\:help)'

#yamllint staff
mkdir -p ~/.config/yamllint
cat << END > ~/.config/yamllint/config
extends: relaxed

rules:
  line-length: disable
END
