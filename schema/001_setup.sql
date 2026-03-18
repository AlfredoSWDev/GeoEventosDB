-- =============================================================
-- GeoEventos DB - Script 001: Setup y extensiones
-- Descripción: Configuración base para el rediseño de la BBDD
-- =============================================================

-- Extensión para generar UUIDs nativamente
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Nota: En PostgreSQL 13+ también puede usarse gen_random_uuid() sin extensión.
-- pgcrypto la garantiza en versiones anteriores (Neon usa Postgres 16, OK).
