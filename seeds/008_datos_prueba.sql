-- =============================================================
-- GeoEventos DB - Seeds: Datos de prueba (rediseño)
-- Solo para entorno de desarrollo LOCAL, NO ejecutar en producción
-- =============================================================

-- -------------------------------------------------------------
-- Variables locales para reutilizar los UUIDs en los INSERTs
-- Se usan DO blocks para poder referenciar entre tablas
-- -------------------------------------------------------------

DO $$
DECLARE
    -- Planes
    plan_free_id        UUID;
    plan_org_id         UUID;
    plan_pro_id         UUID;
    plan_admin_id       UUID;

    -- Usuarios
    user_alfredo_id     UUID;
    user_juan_id        UUID;
    user_maria_id       UUID;

    -- Lugares
    lugar_plaza_id      UUID;
    lugar_bustamante_id UUID;
    lugar_gm_id         UUID;

BEGIN

    -- ----------------------------------------------------------
    -- Recuperar IDs de planes ya insertados en 002_create_planes
    -- ----------------------------------------------------------
    SELECT plan_id INTO plan_free_id   FROM planes WHERE nombre_plan = 'free'        LIMIT 1;
    SELECT plan_id INTO plan_org_id    FROM planes WHERE nombre_plan = 'organizador' LIMIT 1;
    SELECT plan_id INTO plan_admin_id  FROM planes WHERE nombre_plan = 'admin'       LIMIT 1;

    -- ----------------------------------------------------------
    -- Usuarios
    -- ----------------------------------------------------------
    INSERT INTO usuarios (user_id, nombre, correo_electronico, plan_activo, estado)
    VALUES
        (gen_random_uuid(), 'Alfredo Sanchez',  'alfredosanchez.dev@gmail.com', plan_admin_id, 'activo'),
        (gen_random_uuid(), 'Juan Organizador', 'juan@geoeventos.cl',           plan_org_id,   'activo'),
        (gen_random_uuid(), 'Maria Cliente',    'maria@ejemplo.com',            plan_free_id,  'activo')
    ON CONFLICT (correo_electronico) DO NOTHING;

    SELECT user_id INTO user_alfredo_id FROM usuarios WHERE correo_electronico = 'alfredosanchez.dev@gmail.com';
    SELECT user_id INTO user_juan_id    FROM usuarios WHERE correo_electronico = 'juan@geoeventos.cl';
    SELECT user_id INTO user_maria_id   FROM usuarios WHERE correo_electronico = 'maria@ejemplo.com';

    -- ----------------------------------------------------------
    -- Lugares
    -- ----------------------------------------------------------
    INSERT INTO lugares (lugar_id, nombre_lugar, latitud, longitud, estado, registrado_por)
    VALUES
        (gen_random_uuid(), 'Plaza de Armas de Santiago',       -33.4378, -70.6505, 'activo', user_alfredo_id),
        (gen_random_uuid(), 'Parque Bustamante',                -33.4523, -70.6351, 'activo', user_juan_id),
        (gen_random_uuid(), 'Centro Cultural Gabriela Mistral', -33.4431, -70.6503, 'activo', user_alfredo_id);

    SELECT lugar_id INTO lugar_plaza_id      FROM lugares WHERE nombre_lugar = 'Plaza de Armas de Santiago'       LIMIT 1;
    SELECT lugar_id INTO lugar_bustamante_id FROM lugares WHERE nombre_lugar = 'Parque Bustamante'                LIMIT 1;
    SELECT lugar_id INTO lugar_gm_id         FROM lugares WHERE nombre_lugar = 'Centro Cultural Gabriela Mistral' LIMIT 1;

    -- ----------------------------------------------------------
    -- Eventos
    -- ----------------------------------------------------------
    INSERT INTO eventos (event_id, nombre_evento, descripcion_evento, fecha_inicio, fecha_fin, precio, lugar_id, estado, dueno_publicacion)
    VALUES
        (
            gen_random_uuid(),
            'Festival de Verano',
            'Festival de música al aire libre con artistas nacionales e internacionales.',
            '2025-01-15 18:00:00+00',
            '2025-01-17 23:00:00+00',
            15000.00,
            lugar_bustamante_id,
            'finalizado',
            user_juan_id
        ),
        (
            gen_random_uuid(),
            'Feria Gastronómica',
            'Muestra de gastronomía local con más de 30 puestos de comida.',
            '2025-02-01 10:00:00+00',
            '2025-02-01 20:00:00+00',
            0.00,
            lugar_plaza_id,
            'finalizado',
            user_juan_id
        ),
        (
            gen_random_uuid(),
            'Exposición de Arte Emergente',
            'Exposición de artistas emergentes de la escena local.',
            '2025-03-10 10:00:00+00',
            '2025-03-20 19:00:00+00',
            5000.00,
            lugar_gm_id,
            'finalizado',
            user_alfredo_id
        );

    -- ----------------------------------------------------------
    -- Pagos de prueba (Juan pagó plan organizador)
    -- ----------------------------------------------------------
    INSERT INTO pagos (user_id, plan_id, precio_pagado, descuento_aplicado, metodo_pago, estado_pago)
    VALUES
        (user_juan_id, plan_org_id, 9990.00, 0.00, 'tarjeta', 'completado');

    -- ----------------------------------------------------------
    -- Eventos guardados por María (guarda el Festival de Verano)
    -- ----------------------------------------------------------
    UPDATE usuarios
    SET eventos_guardados = ARRAY(
        SELECT event_id FROM eventos WHERE nombre_evento = 'Festival de Verano' LIMIT 1
    )
    WHERE user_id = user_maria_id;

END $$;
