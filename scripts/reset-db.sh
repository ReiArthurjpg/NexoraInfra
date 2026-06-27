#!/bin/bash
# ==============================================================================
# Nexora — Resetar bancos de dados (recria do zero)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "══════════════════════════════════════════════════════════"
echo "  ⚠️  Nexora — Reset completo do banco de dados"
echo "══════════════════════════════════════════════════════════"
echo ""
echo "  ATENÇÃO: Esta ação irá DESTRUIR todos os dados existentes"
echo "  nos bancos 'authnexora' e 'ai_knowledge_base'."
echo ""
read -p "  Deseja continuar? (s/N): " confirm

if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
    echo "  ❌ Operação cancelada."
    exit 0
fi

echo ""
echo "🗑️  Removendo volume do banco de dados..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" down -v

echo ""
echo "📦 Recriando containers e banco..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d --build

echo ""
echo "⏳ Aguardando banco de dados ficar saudável..."
sleep 15

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  ✅ Banco de dados recriado com sucesso!"
echo "══════════════════════════════════════════════════════════"
echo ""
echo "  📊 Databases criados:"
echo "     • authnexora (AuthNexora)"
echo "     • ai_knowledge_base (IANexora)"
echo ""
echo "  👤 Admin padrão:"
echo "     • Email: admin@nexora.com"
echo "     • Senha: Admin@123"
echo ""
