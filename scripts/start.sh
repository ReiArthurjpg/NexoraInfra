#!/bin/bash
# ==============================================================================
# Nexora — Iniciar todo o ecossistema
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "══════════════════════════════════════════════════════════"
echo "  🚀 Nexora — Iniciando ecossistema completo"
echo "══════════════════════════════════════════════════════════"

# Verificar se o .env existe
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "⚠️  Arquivo .env não encontrado. Copiando de .env.example..."
    cp "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env"
    echo "✅ .env criado. Edite com suas credenciais antes de continuar."
    echo ""
fi

# Verificar se os diretórios dos projetos existem
MISSING=0
for DIR in "../AuthNexora" "../IANexora" "../brainNexora"; do
    FULL_PATH="$PROJECT_DIR/$DIR"
    if [ ! -d "$FULL_PATH" ]; then
        echo "❌ Diretório não encontrado: $FULL_PATH"
        MISSING=1
    fi
done

if [ $MISSING -eq 1 ]; then
    echo ""
    echo "⚠️  Certifique-se de que todos os repositórios estejam no mesmo diretório pai."
    exit 1
fi

echo ""
echo "📦 Subindo containers..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d --build

echo ""
echo "⏳ Aguardando banco de dados ficar saudável..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" exec db mysqladmin ping -h localhost -u root -p"${DB_ROOT_PASSWORD:-rootpassword}" --wait=30 2>/dev/null || true

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  ✅ Ecossistema Nexora iniciado com sucesso!"
echo "══════════════════════════════════════════════════════════"
echo ""
echo "  🔐 AuthNexora:    http://localhost:${AUTH_WEB_PORT:-8080}"
echo "  🤖 IANexora:      http://localhost:${IA_WEB_PORT:-8082}"
echo "  🧠 BrainNexora:   http://localhost:${BRAIN_WEB_PORT:-8083}"
echo "  🗄️  phpMyAdmin:    http://localhost:${PHPMYADMIN_PORT:-8081}"
echo ""
