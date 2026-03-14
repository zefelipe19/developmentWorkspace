echo "Instalando Go..."
mkdir temp
mkdir .asdf
cd temp
wget -O go https://go.dev/dl/go1.26.1.linux-amd64.tar.gz
tar -xzf go
export PATH="$PATH:$HOME/temp/go/bin"
go install github.com/asdf-vm/asdf/cmd/asdf@v0.18.1
cd $HOME/go/bin/
cp asdf $HOME/.asdf
cd
mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
