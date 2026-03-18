-- =============================================================
-- GeoEventos DB - Script 006: Tabla pagos
-- Descripción: Historial de pagos de suscripciones por usuario.
--              Cada pago registra qué plan se adquirió, el precio
--              real pagado (considerando descuento), y la fecha.
-- Depende de: 004_create_usuarios.sql, 002_create_planes.sql
-- =============================================================

CREATE TABLE IF NOT EXISTS pagos
(
    pago_id          UUID        NOT NULL DEFAULT gen_random_uuid()
        CONSTRAINT pagos_pk PRIMARY KEY,
    user_id          UUID        NOT NULL
        CONSTRAINT pagos_fk_usuario REFERENCES usuarios (user_id) ON DELETE CASCADE,
    plan_id          UUID        NOT NULL
        CONSTRAINT pagos_fk_plan REFERENCES planes (plan_id) ON DELETE RESTRICT,
    precio_pagado    NUMERIC(10, 2) NOT NULL,
    descuento_aplicado NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
    fecha_pago       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metodo_pago      TEXT,
    estado_pago      TEXT        NOT NULL DEFAULT 'completado'
);

COMMENT ON TABLE pagos IS 'Historial de pagos de suscripciones por usuario';

COMMENT ON COLUMN pagos.pago_id            IS 'Identificador único del pago (UUID)';
COMMENT ON COLUMN pagos.user_id            IS 'FK al usuario que realizó el pago';
COMMENT ON COLUMN pagos.plan_id            IS 'FK al plan adquirido';
COMMENT ON COLUMN pagos.precio_pagado      IS 'Monto real cobrado (después de descuento)';
COMMENT ON COLUMN pagos.descuento_aplicado IS 'Porcentaje de descuento aplicado en este pago';
COMMENT ON COLUMN pagos.fecha_pago         IS 'Timestamp del momento en que se procesó el pago';
COMMENT ON COLUMN pagos.metodo_pago        IS 'Medio de pago: tarjeta, transferencia, etc.';
COMMENT ON COLUMN pagos.estado_pago        IS 'Estado: completado, pendiente, fallido, reembolsado';

CREATE INDEX IF NOT EXISTS pagos_pago_id_index   ON pagos (pago_id);
CREATE INDEX IF NOT EXISTS pagos_user_id_index   ON pagos (user_id);
CREATE INDEX IF NOT EXISTS pagos_plan_id_index   ON pagos (plan_id);
CREATE INDEX IF NOT EXISTS pagos_fecha_pago_index ON pagos (fecha_pago);
