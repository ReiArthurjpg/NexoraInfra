-- =============================================================================
-- AuthNexora — Seed: Usuário Administrador Padrão
-- Email: admin@nexora.com
-- Senha: Admin@123
-- =============================================================================

INSERT INTO users (name, email, password_hash, is_email_verified) 
VALUES (
  'Administrador', 
  'admin@nexora.com', 
  '$argon2id$v=19$m=65536,t=4,p=1$WVVzY0dJck50VzNkQ29yZQ$2IXEHHNWVmmjYpaUIxELe2INWrMwo01TzXIToF3jUrE', 
  1
);
