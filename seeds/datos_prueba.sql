-- =============================================================
-- GeoEventos DB - Seeds: Datos de prueba
-- Solo para entorno de desarrollo LOCAL, NO ejecutar en Render
-- =============================================================

-- Lugares
INSERT INTO lugares (nombre_lugar, ubicacion_lugar, latitud, longitud) VALUES
('Plaza de Armas de Santiago',  'Santiago Centro, Región Metropolitana', -33.4378, -70.6505),
('Parque Bustamante',           'Providencia, Santiago',                 -33.4523, -70.6351),
('Centro Cultural Gabriela Mistral', 'Alameda 227, Santiago',            -33.4431, -70.6503);

-- Usuarios
INSERT INTO usuarios (nombre, tipo_de_usuario, estado_del_usuario, correo_electronico) VALUES
('Alfredo Sanchez',  'admin',       'activo', 'alfredosanchez.dev@gmail.com'),
('Juan Organizador', 'organizador', 'activo', 'juan@geoeventos.cl'),
('Maria Cliente',    'cliente',     'activo', 'maria@ejemplo.com');

-- Eventos
INSERT INTO eventos (nombre_evento, descripcion_evento, vigencia_evento, valor_evento, lugar_evento, latitud, longitud) VALUES
('Festival de Verano',    'Festival de música al aire libre',      '2025-01-15 al 2025-01-17', '$15.000',  'Parque Bustamante',                -33.4523, -70.6351),
('Feria Gastronómica',    'Muestra de gastronomía local',          '2025-02-01',                'Entrada libre', 'Plaza de Armas de Santiago', -33.4378, -70.6505),
('Exposición de Arte',    'Exposición de artistas emergentes',     '2025-03-10 al 2025-03-20', '$5.000',   'Centro Cultural Gabriela Mistral', -33.4431, -70.6503);
