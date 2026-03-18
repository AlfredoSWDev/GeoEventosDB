-- =============================================================
-- GeoEventos DB - Script 007: FK diferida lugares → usuarios
-- Descripción: La FK de lugares.registrado_por se creó sin
--              referencia en 003 (usuarios no existía aún).
--              Este script la añade una vez que usuarios existe.
--
-- IMPORTANTE: Ejecutar SOLO si usaste el orden de creación
--             003 → 004. Si ejecutaste 004 → 003 ya está resuelta.
-- =============================================================

-- Añadir FK solo si no existe ya
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'lugares_fk_usuario'
          AND table_name = 'lugares'
    ) THEN
        ALTER TABLE lugares
            ADD CONSTRAINT lugares_fk_usuario
            FOREIGN KEY (registrado_por)
            REFERENCES usuarios (user_id)
            ON DELETE SET NULL;
    END IF;
END
$$;
