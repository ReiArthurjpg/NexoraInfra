#!/bin/bash
# ==============================================================================
# Nexora — Parar todo o ecossistema
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "══════════════════════════════════════════════════════════"
echo "  🛑 Nexora — Parando ecossistema"
echo "══════════════════════════════════════════════════════════"

docker compose -f "$PROJECT_DIR/docker-compose.yml" down

echo ""
echo "✅ Todos os containers foram parados."
echo ""
echo "💡 Para remover também os volumes (dados do banco), use:"
echo "   docker compose -f $PROJECT_DIR/docker-compose.yml down -v"
echo ""
