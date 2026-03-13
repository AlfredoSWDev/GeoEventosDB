-- =============================================================
-- GeoEventos DB - Script 002: Tabla lugares
-- Descripción: Guarda el lugar geográfico de los eventos
-- =============================================================

CREATE TABLE IF NOT EXISTS lugares
(
    lugar_id        SERIAL
        CONSTRAINT lugares_pk PRIMARY KEY,
    nombre_lugar    TEXT        NOT NULL,
    ubicacion_lugar TEXT        NOT NULL,
    latitud         DOUBLE PRECISION,
    longitud        DOUBLE PRECISION
);

COMMENT ON TABLE lugares IS 'Esta tabla guarda el lugar geográfico de los eventos';

COMMENT ON COLUMN lugares.nombre_lugar    IS 'Nombre descriptivo del lugar';
COMMENT ON COLUMN lugares.ubicacion_lugar IS 'Dirección o descripción textual de la ubicación';
COMMENT ON COLUMN lugares.latitud         IS 'Coordenada latitud (WGS84)';
COMMENT ON COLUMN lugares.longitud        IS 'Coordenada longitud (WGS84)';

CREATE INDEX IF NOT EXISTS lugares_lugar_id_index ON lugares (lugar_id);
