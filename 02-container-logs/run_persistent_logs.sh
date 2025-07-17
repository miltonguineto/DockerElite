#!/bin/bash

# Script para demonstrar a persistência de dados com Docker Volumes.
# O objetivo é mostrar como os logs do Nginx podem ser mantidos
# mesmo após o contêiner ser removido e recriado.

# Garante que o script pare se algum comando falhar
set -e

# --- Função de Limpeza ---
# Esta função garante que contêineres e volumes de execuções anteriores
# sejam removidos antes de começar, para evitar erros.
cleanup() {
    echo "\n>>> Realizando limpeza de recursos Docker..."
    docker stop servidor-com-logs servidor-novo 2>/dev/null || true
    docker rm servidor-com-logs servidor-novo 2>/dev/null || true
    docker volume rm nginx_logs 2>/dev/null || true
    echo ">>> Limpeza concluída."
}

# Executa a limpeza no início e no final do script
trap cleanup EXIT
cleanup

echo "### INÍCIO DA DEMONSTRAÇÃO DE VOLUMES DOCKER ###"

echo "\n=================================================="
echo ">> Passo 1: Criando um volume Docker chamado 'nginx_logs'..."
echo "=================================================="
# 'docker volume create' cria um volume gerenciado pelo Docker para persistir dados.
docker volume create nginx_logs
echo "\nVolume criado:"
docker volume ls

echo "\n(Pressione qualquer tecla para continuar...)"
read -n 1 -s

echo "\n\n=================================================="
echo ">> Passo 2: Iniciando um contêiner e montando o volume..."
echo "=================================================="
# A flag '-v' (ou --volume) monta o volume 'nginx_logs' no diretório '/var/log/nginx' do contêiner.
# Formato: -v <nome_do_volume>:<caminho_no_container>
docker run --name servidor-com-logs -d -p 8080:80 -v nginx_logs:/var/log/nginx nginx
echo "\nContêiner 'servidor-com-logs' está no ar e conectado ao volume."
docker ps

echo "\n\n=================================================="
echo ">> Passo 3: Gerando logs de acesso..."
echo "=================================================="
# Usamos 'curl' para fazer requisições ao Nginx, que por sua vez gera logs de acesso.
echo "Acessando http://localhost:8080..."
curl -s -o /dev/null http://localhost:8080
curl -s -o /dev/null http://localhost:8080
echo "Logs gerados! Verificando o arquivo de log dentro do contêiner:"
docker exec servidor-com-logs cat /var/log/nginx/access.log

echo "\n(Pressione qualquer tecla para parar o contêiner...)"
read -n 1 -s

echo "\n\n=================================================="
echo ">> Passo 4: Parando e removendo o contêiner 'servidor-com-logs'..."
echo "=================================================="
docker stop servidor-com-logs
docker rm servidor-com-logs
echo "\nContêiner removido. Note que o volume 'nginx_logs' ainda existe:"
docker volume ls

echo "\n(Pressione qualquer tecla para recriar o contêiner e verificar a persistência...)"
read -n 1 -s

echo "\n\n=================================================="
echo ">> Passo 5: Criando um NOVO contêiner e validando os logs antigos..."
echo "=================================================="
echo "Iniciando 'servidor-novo' e conectando ao MESMO volume 'nginx_logs'..."
docker run --name servidor-novo -d -p 8080:80 -v nginx_logs:/var/log/nginx nginx
echo "\nAgora, vamos ler os logs no novo contêiner. Os logs antigos devem estar lá:"
docker exec servidor-novo cat /var/log/nginx/access.log

echo "\n### SUCESSO! Os logs persistiram entre os contêineres. ###"
echo "\n### DEMONSTRAÇÃO CONCLUÍDA ###"

