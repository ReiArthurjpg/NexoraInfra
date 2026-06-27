#!/bin/bash
# ==============================================================================
# Nexora — Health Check de todos os serviços
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "══════════════════════════════════════════════════════════"
echo "  🏥 Nexora — Health Check"
echo "══════════════════════════════════════════════════════════"
echo ""

# Carregar variáveis de ambiente
if [ -f "$PROJECT_DIR/.env" ]; then
    export $(grep -v '^#' "$PROJECT_DIR/.env" | xargs 2>/dev/null) || true
fi

AUTH_PORT="${AUTH_WEB_PORT:-8080}"
IA_PORT="${IA_WEB_PORT:-8082}"
BRAIN_PORT="${BRAIN_WEB_PORT:-8083}"

ERRORS=0

# Verificar containers rodando
echo "📦 Verificando containers..."
RUNNING=$(docker compose -f "$PROJECT_DIR/docker-compose.yml" ps --status running --format "{{.Name}}" 2>/dev/null | wc -l)
TOTAL=$(docker compose -f "$PROJECT_DIR/docker-compose.yml" ps --format "{{.Name}}" 2>/dev/null | wc -l)
echo "   Containers rodando: $RUNNING/$TOTAL"
echo ""

# Health check dos endpoints
echo "🌐 Verificando endpoints..."

# AuthNexora
if curl -sf "http://localhost:$AUTH_PORT/" > /dev/null 2>&1; then
    echo "   ✅ AuthNexora    (http://localhost:$AUTH_PORT)"
else
    echo "   ❌ AuthNexora    (http://localhost:$AUTH_PORT)"
    ERRORS=$((ERRORS + 1))
fi

# IANexora
if curl -sf "http://localhost:$IA_PORT/api/health" > /dev/null 2>&1; then
    echo "   ✅ IANexora      (http://localhost:$IA_PORT)"
else
    echo "   ❌ IANexora      (http://localhost:$IA_PORT)"
    ERRORS=$((ERRORS + 1))
fi

# BrainNexora
if curl -sf "http://localhost:$BRAIN_PORT/api/health" > /dev/null 2>&1; then
    echo "   ✅ BrainNexora   (http://localhost:$BRAIN_PORT)"
else
    echo "   ❌ BrainNexora   (http://localhost:$BRAIN_PORT)"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# Verificar banco de dados
echo "🗄️  Verificando banco de dados..."
if docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T db mysqladmin ping -h localhost -u root -p"${DB_ROOT_PASSWORD:-rootpassword}" > /dev/null 2>&1; then
    echo "   ✅ MySQL está respondendo"
    
    # Verificar databases
    DBS=$(docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T db mysql -u root -p"${DB_ROOT_PASSWORD:-rootpassword}" -e "SHOW DATABASES;" 2>/dev/null | grep -E "authnexora|ai_knowledge_base" | wc -l)
    if [ "$DBS" -ge 2 ]; then
        echo "   ✅ Databases criados (authnexora, ai_knowledge_base)"
    else
        echo "   ⚠️  Nem todos os databases foram criados ($DBS/2)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ❌ MySQL não está respondendo"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "══════════════════════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo "  ✅ Todos os serviços estão saudáveis!"
else
    echo "  ⚠️  $ERRORS problema(s) encontrado(s)"
fi
echo "══════════════════════════════════════════════════════════"
echo ""

exit $ERRORS
