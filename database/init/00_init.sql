-- =============================================================================
-- Nexora — Script de Inicialização Completo do Banco de Dados
-- Executado automaticamente pelo MySQL no primeiro boot do container
-- (via /docker-entrypoint-initdb.d/)
-- =============================================================================

-- =============================================================================
-- 1. DATABASE: authnexora (AuthNexora)
-- =============================================================================
CREATE DATABASE IF NOT EXISTS `authnexora`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `authnexora`;

-- Schema
SOURCE /docker-entrypoint-initdb.d/schemas/authnexora/001_initial_schema.sql;

-- Seeds
SOURCE /docker-entrypoint-initdb.d/seeds/authnexora/001_admin_user.sql;

-- =============================================================================
-- 2. DATABASE: ai_knowledge_base (IANexora)
-- =============================================================================
CREATE DATABASE IF NOT EXISTS `ai_knowledge_base`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `ai_knowledge_base`;

-- Schema
SOURCE /docker-entrypoint-initdb.d/schemas/ianexora/001_initial_schema.sql;
