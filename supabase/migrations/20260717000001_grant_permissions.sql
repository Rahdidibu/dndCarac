-- Accorder l'accès au schéma public aux rôles de Supabase
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

-- Accorder les droits sur toutes les tables et séquences actuelles du schéma public
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- S'assurer que les futures tables créées auront également ces privilèges par défaut
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;
