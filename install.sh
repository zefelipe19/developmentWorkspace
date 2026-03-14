#!/bin/bash
echo "Instalando container..."
distrobox assemble create --file image.ini
echo "Container debian criado..."
echo "entrando no container..."

ls
cp ./zshrc $HOME/DistroBox/Debian/
cp ./install_asdf.sh $HOME/DistroBox/Debian/
cd $HOME/DistroBox/Debian/

mv zshrc .zshrc

echo "Execute install_asdf para instalar o asdf"
distrobox enter debian

