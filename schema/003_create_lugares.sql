-- =============================================================
-- GeoEventos DB - Script 003: Tabla lugares
-- Descripción: Lugares geográficos registrados en la plataforma.
--              Cada lugar es registrado por un usuario.
-- Depende de: 004_create_usuarios.sql (FK registrado_por)
-- =============================================================

CREATE TABLE IF NOT EXISTS lugares
(
    lugar_id        UUID        NOT NULL DEFAULT gen_random_uuid()
        CONSTRAINT lugares_pk PRIMARY KEY,
    nombre_lugar    TEXT        NOT NULL,
    latitud         DOUBLE PRECISION NOT NULL,
    longitud        DOUBLE PRECISION NOT NULL,
    estado          TEXT        NOT NULL DEFAULT 'activo',
    fecha_registro  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    registrado_por  UUID
        CONSTRAINT lugares_fk_usuario REFERENCES usuarios (user_id) ON DELETE SET NULL
);

COMMENT ON TABLE lugares IS 'Lugares geográficos donde se realizan los eventos';

COMMENT ON COLUMN lugares.lugar_id       IS 'Identificador único del lugar (UUID)';
COMMENT ON COLUMN lugares.nombre_lugar   IS 'Nombre descriptivo del lugar';
COMMENT ON COLUMN lugares.latitud        IS 'Coordenada latitud (WGS84)';
COMMENT ON COLUMN lugares.longitud       IS 'Coordenada longitud (WGS84)';
COMMENT ON COLUMN lugares.estado         IS 'Estado: activo, inactivo';
COMMENT ON COLUMN lugares.fecha_registro IS 'Timestamp de cuando fue registrado el lugar';
COMMENT ON COLUMN lugares.registrado_por IS 'FK al usuario que registró el lugar';

CREATE INDEX IF NOT EXISTS lugares_lugar_id_index     ON lugares (lugar_id);
CREATE INDEX IF NOT EXISTS lugares_registrado_por_idx ON lugares (registrado_por);
