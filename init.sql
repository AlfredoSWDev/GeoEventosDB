-- =============================================================
-- GeoEventos DB - Script maestro
-- Ejecuta este archivo para crear toda la base de datos
-- desde cero en cualquier entorno (local o Render)
--
-- Uso:
--   psql -U <usuario> -d <base_de_datos> -f init.sql
-- =============================================================

\echo '>>> Creando tabla lugares...'
\i schema/002_create_lugares.sql

\echo '>>> Creando tabla usuarios...'
\i schema/003_create_usuarios.sql

\echo '>>> Creando tabla eventos...'
\i schema/004_create_eventos.sql

\echo '>>> Base de datos GeoEventos inicializada correctamente.'
