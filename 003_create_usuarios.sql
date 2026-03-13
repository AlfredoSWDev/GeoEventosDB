-- =============================================================
-- GeoEventos DB - Script 003: Tabla usuarios
-- Descripción: Guarda los usuarios de la plataforma GeoEventos
-- =============================================================

CREATE TABLE IF NOT EXISTS usuarios
(
    user_id              SERIAL
        CONSTRAINT usuarios_pk PRIMARY KEY,
    nombre               TEXT        NOT NULL,
    tipo_de_usuario      TEXT        NOT NULL DEFAULT 'cliente',
    estado_del_usuario   TEXT        NOT NULL DEFAULT 'activo',
    correo_electronico   TEXT        NOT NULL UNIQUE,
    favoritos            TEXT,
    eventos_auspiciados  TEXT
);

COMMENT ON TABLE usuarios IS 'Esta tabla guarda los usuarios de la plataforma';

COMMENT ON COLUMN usuarios.nombre              IS 'Nombre completo del usuario';
COMMENT ON COLUMN usuarios.tipo_de_usuario     IS 'Rol del usuario: cliente, organizador, admin';
COMMENT ON COLUMN usuarios.estado_del_usuario  IS 'Estado: activo, inactivo, suspendido';
COMMENT ON COLUMN usuarios.correo_electronico  IS 'Correo único del usuario';
COMMENT ON COLUMN usuarios.favoritos           IS 'IDs de eventos marcados como favoritos';
COMMENT ON COLUMN usuarios.eventos_auspiciados IS 'IDs de eventos auspiciados por el usuario';

CREATE INDEX IF NOT EXISTS usuarios_user_id_index           ON usuarios (user_id);
CREATE INDEX IF NOT EXISTS usuarios_correo_electronico_index ON usuarios (correo_electronico);
