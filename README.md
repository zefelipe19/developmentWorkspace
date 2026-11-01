# Ambiente Debian de desenvolvimento

Este projeto cria um ambiente Debian reproduzível para desenvolvimento usando Distrobox. Compiladores, bibliotecas e ferramentas de desenvolvimento ficam no container; o ambiente continua integrado ao host e pode encaminhar comandos selecionados para ele.

## Requisitos

- Linux com Distrobox instalado.
- Docker ou Podman instalado e configurado no host como mecanismo de containers do Distrobox.
- Para usar `docker` de dentro do ambiente, o comando Docker precisa estar disponível e configurado no host.

## Instalação

Clone este repositório e execute, a partir de qualquer diretório:

```bash
./install.sh
```

O script cria o container `dev-workspace` com a imagem Debian Toolbox 13 definida em `image.ini`, instala o asdf no próprio container e abre um shell nele. O asdf fica disponível em `/usr/local/bin/asdf`, sem plugins ou versões de linguagens pré-instalados. A versão fica fixada em `install_asdf.sh` para manter novas instalações consistentes. O manifesto usa `replace=false` para preservar o ambiente existente em execuções seguintes. Para remover e recriar o container manualmente:

```bash
distrobox assemble rm --file /caminho/para/image.ini
distrobox assemble create --file /caminho/para/image.ini
```

## Ferramentas do host

O manifesto encaminha `docker` pelo `distrobox-host-exec`. O comando usa a instalação e o daemon do host; o container não instala nem inicia um daemon Docker próprio. Use `docker compose` para Compose v2. A disponibilidade depende da configuração do Docker no host e das permissões do usuário para acessar o daemon.

Para encaminhar outro executável do host, adicione uma linha `init_hooks` no `image.ini`, por exemplo:

```ini
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman;
```

Prefira instalar bibliotecas de desenvolvimento pelo `additional_packages` do manifesto. Bibliotecas compartilhadas do host podem ter versões ou ABIs incompatíveis com os programas do Debian. O Distrobox já integra diretórios e recursos usuais do host; montagens adicionais podem ser declaradas com `volume` quando necessárias.

## Personalização e replicação

Edite `image.ini` para ajustar a imagem Debian e os pacotes. `additional_packages` pode aparecer em várias linhas: o Distrobox combina as listas. O manifesto documenta o conjunto base, mas versões de pacotes vindas dos repositórios Debian podem avançar com o tempo; para reproduções estritas, fixe versões dos pacotes ou mantenha uma imagem OCI própria identificada por tag imutável.
