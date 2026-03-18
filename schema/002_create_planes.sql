-- =============================================================
-- GeoEventos DB - Script 002: Tabla planes
-- Descripción: Define los planes de suscripción de la plataforma.
--              Los permisos de cada usuario se derivan del plan activo.
-- =============================================================

CREATE TABLE IF NOT EXISTS planes
(
    plan_id          UUID        NOT NULL DEFAULT gen_random_uuid()
        CONSTRAINT planes_pk PRIMARY KEY,
    nombre_plan      TEXT        NOT NULL,
    caracteristicas  TEXT,
    precio           NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    descuento        NUMERIC(5, 2)  NOT NULL DEFAULT 0.00,
    estado           TEXT        NOT NULL DEFAULT 'activo',
    vigencia         TEXT
);

COMMENT ON TABLE planes IS 'Planes de suscripción disponibles en GeoEventos';

COMMENT ON COLUMN planes.plan_id         IS 'Identificador único del plan (UUID)';
COMMENT ON COLUMN planes.nombre_plan     IS 'Nombre del plan: free, pro, organizador, etc.';
COMMENT ON COLUMN planes.caracteristicas IS 'Descripción de las características y permisos del plan';
COMMENT ON COLUMN planes.precio          IS 'Precio base del plan (CLP u otra moneda)';
COMMENT ON COLUMN planes.descuento       IS 'Porcentaje de descuento aplicable';
COMMENT ON COLUMN planes.estado          IS 'Estado del plan: activo, inactivo, descontinuado';
COMMENT ON COLUMN planes.vigencia        IS 'Duración o período de vigencia del plan (ej: mensual, anual)';

CREATE INDEX IF NOT EXISTS planes_plan_id_index ON planes (plan_id);

-- -------------------------------------------------------------
-- Planes base del sistema
-- -------------------------------------------------------------
INSERT INTO planes (plan_id, nombre_plan, caracteristicas, precio, descuento, estado, vigencia) VALUES
(gen_random_uuid(), 'free',         'Acceso básico: ver eventos, guardar favoritos',               0.00,   0.00, 'activo', NULL),
(gen_random_uuid(), 'organizador',  'Crear y gestionar eventos, hasta 5 eventos activos',          9990.00, 0.00, 'activo', 'mensual'),
(gen_random_uuid(), 'pro',          'Crear eventos ilimitados, estadísticas, destacar eventos',   19990.00, 0.00, 'activo', 'mensual'),
(gen_random_uuid(), 'admin',        'Acceso total a la plataforma, panel de administración',       0.00,   0.00, 'activo', NULL);
