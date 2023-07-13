# Setup your vim rocks!
tmp="$(mktemp)"
rm "${tmp}"
wget -c -O "${tmp}"  https://github.com/korkin25/vimrocks/raw/main/setup.sh
bash -x "${tmp}"
rm "${tmp}"

