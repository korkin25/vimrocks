#!/bin/bash

rm -rf ~/.vim/bundle/Vundle.vim ~/.vim/pack/vendor/start/indentLine ~/.vimrc

sudo apt -y install vim-nox git links2 flake8 ansible-lint yamllint shellcheck npm python3-pip universal-ctags

npm_packages=("htmlhint" "jsonlint")

for package in "${npm_packages[@]}"; do
    if ! command -v "$package" &> /dev/null; then
        echo "$package is not installed. Running npm install $package..."
        sudo npm install -g "$package"
    fi
done

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
set nonumber
set mouse=a

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
Plugin 'avakhov/vim-yaml'
Plugin 'egonschiele/salt-vim'
Plugin 'wincent/command-t'
Bundle 'chase/vim-ansible-yaml'
Bundle 'pedrohdz/vim-yaml-folds'
Plugin 'dense-analysis/ale'
Plugin 'github/copilot.vim'
Plugin 'rhysd/vim-github-support'
Plugin 'hankei6km/ale-linter-actionlint.vim'
Plugin 'hashivim/vim-terraform'

" Additional plugins or settings...

call vundle#end()
filetype plugin indent on

" Plugin Settings

" Commentary Plugin
nmap gcc <Plug>CommentaryLine
vmap gc <Plug>Commentary

" Fugitive Plugin
let mapleader = '\\'
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

set tags=./tags,tags;/home/kk573
set foldmethod=syntax  " or set foldmethod=indent

" Enable ALE
let g:ale_linters = {
    \ 'yaml': ['yamllint', 'ansible-lint'],
    \ 'ansible': ['ansible-lint'],
    \ 'salt': ['salt-lint'],
    \ 'jinja': ['salt-lint'],
    \ 'sh': ['shellcheck'],
    \ 'html': ['htmlhint'],
    \ 'json': ['jsonlint'],
    \ 'python': ['flake8']
    \ }

let g:ale_linter_aliases = {
      \ 'sls': 'salt'
      \}

" Set ALE to show warnings
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_info_str = 'I'
let g:indentLine_char = '⦙'

" salt staff
augroup salt_syn
  au BufNewFile,BufRead *.sls set filetype=salt.yaml
  au BufNewFile,BufRead *.jinja set filetype=salt.json
augroup END

" .vimrc auto-reload staff
augroup myvimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" lint staff
let g:ale_lint_on_text_changed = 'always' 

" lint errors navigation

" key bindings
nnoremap <F2>  :w<CR>
nnoremap <F3>  :Explore<CR>
" F5 copy vim clipboard to KDE keyboard
nnoremap <F5>  "+y
nnoremap <F6>  :ALEPrevious<CR>
nnoremap <F7>  :ALENext<CR>
nnoremap <C-N> :vnew<CR>            
nnoremap <C-O> :new<CR>

filetype plugin indent on

" Path to salt-lint
let g:ale_salt_sls_saltlint_executable = expand('$HOME') . '/bin/salt-lint'

VIMRC

vim +PluginInstall +qall

git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"

echo Folding helm
links2 -dump http://vimcasts.org/episodes/how-to-fold/ | grep -E '(^[[:space:]]+z.+$|\:help)'

#yamllint staff
mkdir -p "${HOME}/.config/yamllint"
cat << YAMLLINT > "${HOME}/.config/yamllint/config"
extends: relaxed

rules:
  line-length: disable
YAMLLINT

#salt-lint staff
mkdir -p "${HOME}/.config/salt-lint" > /dev/null 2>&1
cat << SALTCONFIG > "${HOME}/.config/salt-lint/.salt-lint"
ignored:
  - 203
  - 204
SALTCONFIG

mkdir "${HOME}/bin" >/dev/null 2>&1
cat << SALTSCRIPT > "${HOME}/bin/salt-lint"
#!/bin/bash

one_dir_salt_salt_lint=/opt/saltstack/salt/pypath/bin/salt-lint

if [ -x "/opt/saltstack/salt/pypath/bin/salt-lint" ]; then
    /opt/saltstack/salt/pypath/bin/salt-lint -c ~/.config/salt-lint/.salt-lint \$*
else
    salt-lint -c ~/.config/salt-lint/.salt-lint \$*
fi
SALTSCRIPT
chmod +x "${HOME}/bin/salt-lint"

