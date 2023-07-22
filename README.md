# Setup your vim rocks!
export tmp=$(mktemp);  rm "${tmp}" > /dev/null 2>&1 ; wget -c -O "${tmp}" https://github.com/korkin25/vimrocks/raw/main/setup.sh  ; bash -x "${tmp}"; rm "${tmp}"

