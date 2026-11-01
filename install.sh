#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v distrobox >/dev/null 2>&1; then
  echo "Erro: Distrobox não encontrado. Instale-o no host e tente novamente." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1 && ! command -v podman >/dev/null 2>&1; then
  echo "Erro: instale Docker ou Podman no host para o Distrobox criar o container." >&2
  exit 1
fi

echo "Criando o ambiente Debian de desenvolvimento..."
distrobox assemble create --file "$SCRIPT_DIR/image.ini"

echo "Instalando asdf dentro do container..."
distrobox enter dev-workspace -- bash -s < "$SCRIPT_DIR/install_asdf.sh"

echo "Ambiente criado. Acessando o container Debian..."
exec distrobox enter dev-workspace

