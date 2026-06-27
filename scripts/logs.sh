#!/bin/bash
# ==============================================================================
# Nexora — Exibir logs de todos os containers
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Se um nome de serviço foi passado como argumento, mostra apenas esse
if [ -n "$1" ]; then
    echo "📋 Logs do serviço: $1"
    echo ""
    docker compose -f "$PROJECT_DIR/docker-compose.yml" logs -f "$1"
else
    echo "══════════════════════════════════════════════════════════"
    echo "  📋 Nexora — Logs de todos os serviços"
    echo "══════════════════════════════════════════════════════════"
    echo ""
    echo "  💡 Para ver logs de um serviço específico:"
    echo "     ./logs.sh db"
    echo "     ./logs.sh authnexora-api"
    echo "     ./logs.sh ianexora-api"
    echo "     ./logs.sh brainnexora-api"
    echo ""
    docker compose -f "$PROJECT_DIR/docker-compose.yml" logs -f
fi
