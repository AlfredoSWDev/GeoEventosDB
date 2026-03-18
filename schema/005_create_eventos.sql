-- =============================================================
-- GeoEventos DB - Script 005: Tabla eventos
-- Descripción: Eventos publicados en la plataforma GeoEventos.
-- Depende de: 003_create_lugares.sql, 004_create_usuarios.sql
-- =============================================================

CREATE TABLE IF NOT EXISTS eventos
(
    event_id           UUID        NOT NULL DEFAULT gen_random_uuid()
        CONSTRAINT eventos_pk PRIMARY KEY,
    nombre_evento      TEXT        NOT NULL,
    descripcion_evento TEXT,
    fecha_inicio       TIMESTAMPTZ NOT NULL,
    fecha_fin          TIMESTAMPTZ,
    horarios           TEXT,
    precio             NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    imagenes           TEXT,
    lugar_id           UUID
        CONSTRAINT eventos_fk_lugar REFERENCES lugares (lugar_id) ON DELETE SET NULL,
    estado             TEXT        NOT NULL DEFAULT 'activo',
    fecha_creacion     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    dueno_publicacion  UUID
        CONSTRAINT eventos_fk_usuario REFERENCES usuarios (user_id) ON DELETE SET NULL
);

COMMENT ON TABLE eventos IS 'Eventos publicados en la plataforma GeoEventos';

COMMENT ON COLUMN eventos.event_id           IS 'Identificador único del evento (UUID)';
COMMENT ON COLUMN eventos.nombre_evento      IS 'Nombre del evento';
COMMENT ON COLUMN eventos.descripcion_evento IS 'Descripción detallada del evento';
COMMENT ON COLUMN eventos.fecha_inicio       IS 'Fecha y hora de inicio del evento';
COMMENT ON COLUMN eventos.fecha_fin          IS 'Fecha y hora de finalización del evento (opcional)';
COMMENT ON COLUMN eventos.horarios           IS 'Descripción de horarios específicos dentro del evento';
COMMENT ON COLUMN eventos.precio             IS 'Precio de entrada (0.00 = entrada libre)';
COMMENT ON COLUMN eventos.imagenes           IS 'URLs de imágenes en IMGBB separadas por coma';
COMMENT ON COLUMN eventos.lugar_id           IS 'FK al lugar donde se realiza el evento';
COMMENT ON COLUMN eventos.estado             IS 'Estado: activo, cancelado, finalizado, borrador';
COMMENT ON COLUMN eventos.fecha_creacion     IS 'Timestamp de creación de la publicación';
COMMENT ON COLUMN eventos.dueno_publicacion  IS 'FK al usuario que creó la publicación';

CREATE INDEX IF NOT EXISTS eventos_event_id_index          ON eventos (event_id);
CREATE INDEX IF NOT EXISTS eventos_lugar_id_index          ON eventos (lugar_id);
CREATE INDEX IF NOT EXISTS eventos_dueno_publicacion_index ON eventos (dueno_publicacion);
CREATE INDEX IF NOT EXISTS eventos_fecha_inicio_index      ON eventos (fecha_inicio);
CREATE INDEX IF NOT EXISTS eventos_estado_index            ON eventos (estado);
