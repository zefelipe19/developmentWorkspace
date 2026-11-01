#!/usr/bin/env bash
set -Eeuo pipefail

# Pin the release so each newly created container gets the same asdf version.
ASDF_VERSION="v0.20.2"

case "$(uname -m)" in
  x86_64) ASDF_ARCH="amd64" ;;
  aarch64|arm64) ASDF_ARCH="arm64" ;;
  *)
    echo "Arquitetura não suportada pelo instalador do asdf: $(uname -m)" >&2
    exit 1
    ;;
esac

if [[ -x /usr/local/bin/asdf ]] && /usr/local/bin/asdf --version | grep -Fq "$ASDF_VERSION"; then
  echo "asdf $ASDF_VERSION já está instalado no container."
  exit 0
fi

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

ARCHIVE="asdf-${ASDF_VERSION}-linux-${ASDF_ARCH}.tar.gz"
URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${ARCHIVE}"

echo "Baixando asdf ${ASDF_VERSION} (${ASDF_ARCH})..."
curl --fail --location --silent --show-error "$URL" --output "$TEMP_DIR/$ARCHIVE"
tar -xzf "$TEMP_DIR/$ARCHIVE" -C "$TEMP_DIR"

if [[ ! -f "$TEMP_DIR/asdf" ]]; then
  echo "O arquivo baixado não contém o executável esperado: asdf" >&2
  exit 1
fi

sudo install -m 0755 "$TEMP_DIR/asdf" /usr/local/bin/asdf
echo "asdf $(/usr/local/bin/asdf --version) instalado em /usr/local/bin/asdf."
