-- =============================================================
-- GeoEventos DB - Script 004: Tabla eventos
-- Descripción: Guarda los eventos de la plataforma GeoEventos
-- =============================================================

CREATE TABLE IF NOT EXISTS eventos
(
    event_id           SERIAL
        CONSTRAINT eventos_pk PRIMARY KEY,
    nombre_evento      TEXT             NOT NULL,
    descripcion_evento TEXT,
    vigencia_evento    TEXT,
    valor_evento       TEXT,
    lugar_evento       TEXT             NOT NULL,
    fotos_evento       TEXT,
    latitud            DOUBLE PRECISION,
    longitud           DOUBLE PRECISION
);

COMMENT ON TABLE eventos IS 'En esta tabla vamos a guardar los eventos';

COMMENT ON COLUMN eventos.nombre_evento      IS 'Nombre del evento';
COMMENT ON COLUMN eventos.descripcion_evento IS 'Descripción detallada del evento';
COMMENT ON COLUMN eventos.vigencia_evento    IS 'Fecha o rango de vigencia del evento';
COMMENT ON COLUMN eventos.valor_evento       IS 'Precio o valor de entrada del evento';
COMMENT ON COLUMN eventos.lugar_evento       IS 'Nombre o descripción del lugar del evento';
COMMENT ON COLUMN eventos.fotos_evento       IS 'URL o referencia a las fotos del evento';
COMMENT ON COLUMN eventos.latitud            IS 'Coordenada latitud del evento (WGS84)';
COMMENT ON COLUMN eventos.longitud           IS 'Coordenada longitud del evento (WGS84)';

CREATE INDEX IF NOT EXISTS eventos_event_id_index ON eventos (event_id);
