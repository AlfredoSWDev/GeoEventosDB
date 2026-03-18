-- =============================================================
-- GeoEventos DB - Script 004: Tabla usuarios
-- Descripción: Usuarios de la plataforma GeoEventos.
--              El tipo de permisos se deriva del plan activo.
--              Los eventos guardados se almacenan como array de UUIDs.
-- Depende de: 002_create_planes.sql (FK plan_activo)
-- =============================================================

CREATE TABLE IF NOT EXISTS usuarios
(
    user_id            UUID        NOT NULL DEFAULT gen_random_uuid()
        CONSTRAINT usuarios_pk PRIMARY KEY,
    nombre             TEXT        NOT NULL,
    correo_electronico TEXT        NOT NULL UNIQUE,
    plan_activo        UUID
        CONSTRAINT usuarios_fk_plan REFERENCES planes (plan_id) ON DELETE SET NULL,
    estado             TEXT        NOT NULL DEFAULT 'activo',
    eventos_guardados  UUID[]      DEFAULT '{}',
    enlaces_contacto   TEXT,
    fecha_registro     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE usuarios IS 'Usuarios registrados en la plataforma GeoEventos';

COMMENT ON COLUMN usuarios.user_id            IS 'Identificador único del usuario (UUID)';
COMMENT ON COLUMN usuarios.nombre             IS 'Nombre completo del usuario';
COMMENT ON COLUMN usuarios.correo_electronico IS 'Correo único (usado también para OAuth)';
COMMENT ON COLUMN usuarios.plan_activo        IS 'FK al plan actual del usuario; define sus permisos';
COMMENT ON COLUMN usuarios.estado             IS 'Estado: activo, inactivo, suspendido';
COMMENT ON COLUMN usuarios.eventos_guardados  IS 'Array de UUIDs de eventos guardados como favoritos';
COMMENT ON COLUMN usuarios.enlaces_contacto   IS 'Links de redes sociales u otros medios de contacto';
COMMENT ON COLUMN usuarios.fecha_registro     IS 'Timestamp de registro del usuario';

CREATE INDEX IF NOT EXISTS usuarios_user_id_index             ON usuarios (user_id);
CREATE INDEX IF NOT EXISTS usuarios_correo_electronico_index  ON usuarios (correo_electronico);
CREATE INDEX IF NOT EXISTS usuarios_plan_activo_index         ON usuarios (plan_activo);
