#!/bin/bash

# Script para demonstrar o ciclo de vida básico de um contêiner Docker.
# O objetivo é mostrar como é simples e rápido subir um serviço com Docker.

# Garante que o script pare se algum comando falhar
set -e

echo "### INÍCIO DA DEMONSTRAÇÃO DOCKER ###"

echo "\n=================================================="
echo ">> Passo 1: Baixando a imagem 'nginx' do Docker Hub..."
echo "=================================================="
# O comando 'pull' baixa a imagem de um registro, por padrão o Docker Hub.
docker pull nginx

echo "\n=================================================="
echo ">> Passo 2: Iniciando um contêiner Nginx chamado 'meu-servidor'..."
echo "=================================================="
# 'docker run' cria e inicia um contêiner.
# --name: dá um nome ao contêiner para fácil referência.
# -d: executa o contêiner em modo "detached" (em segundo plano).
# -p 8080:80: mapeia a porta 8080 da sua máquina (host) para a porta 80 do contêiner.
docker run --name meu-servidor -d -p 8080:80 nginx

echo "\n>>> O servidor Nginx está no ar!"
echo ">>> Você pode acessá-lo no seu navegador em http://localhost:8080"
echo "\n(Pressione qualquer tecla para continuar...)"
read -n 1 -s

echo "\n=================================================="
echo ">> Passo 3: Listando os contêineres em execução..."
echo "=================================================="
# 'docker ps' mostra todos os contêineres que estão atualmente em execução.
docker ps

echo "\n(Pressione qualquer tecla para parar e remover o contêiner...)"
read -n 1 -s

echo "\n=================================================="
echo ">> Passo 4: Parando e removendo o contêiner 'meu-servidor'..."
echo "=================================================="
# 'docker stop' para um contêiner em execução.
docker stop meu-servidor
# 'docker rm' remove um contêiner que já foi parado.
docker rm meu-servidor

echo "\n=================================================="
echo ">> Passo 5: Listando todos os contêineres (incluindo os parados)..."
echo "=================================================="
# A flag '-a' no 'docker ps' mostra todos os contêineres, até mesmo os que não estão em execução.
# Como removemos o nosso, a lista deve estar vazia (a menos que você tenha outros contêineres).
docker ps -a

echo "\n### DEMONSTRAÇÃO CONCLUÍDA ###"

