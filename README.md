# GeoEventosDB 🗺️

Base de datos PostgreSQL de la plataforma **GeoEventos** — sistema B2B de gestión de eventos geolocalizados.

**Administrador:** Alfredo Sanchez  
**Plataforma de producción:** [Neon](https://neon.tech)  
**Motor:** PostgreSQL 16+

---

## Estructura del repositorio

```
GeoEventosDB/
├── schema/
│   ├── 001_setup.sql                    # Extensiones (pgcrypto)
│   ├── 002_create_planes.sql            # Tabla de planes de suscripción
│   ├── 003_create_lugares.sql           # Tabla de lugares geográficos
│   ├── 004_create_usuarios.sql          # Tabla de usuarios
│   ├── 005_create_eventos.sql           # Tabla de eventos
│   ├── 006_create_pagos.sql             # Tabla de historial de pagos
│   └── 007_add_fk_lugares_usuario.sql   # FK diferida lugares → usuarios
├── seeds/
│   └── 008_datos_prueba.sql             # Datos de prueba (solo desarrollo local)
└── README.md
```

---

## Diagrama de relaciones

```
planes ◄──────────── usuarios ◄──────────── lugares
  ▲                     │                      ▲
  │                     │                      │
pagos             eventos_guardados          eventos
(FK: plan_id)     (UUID[] en columna)        (FK: lugar_id)
(FK: user_id)                                (FK: dueno_publicacion → usuarios)
```

---

## Tablas

### `planes`
Define los planes de suscripción. Los permisos de cada usuario se derivan del plan activo que tiene asignado.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `plan_id` | UUID (PK) | Identificador único |
| `nombre_plan` | TEXT NOT NULL | `free`, `organizador`, `pro`, `admin` |
| `caracteristicas` | TEXT | Descripción de permisos incluidos |
| `precio` | NUMERIC(10,2) | Precio base del plan |
| `descuento` | NUMERIC(5,2) | Porcentaje de descuento aplicable |
| `estado` | TEXT NOT NULL | `activo`, `inactivo`, `descontinuado` |
| `vigencia` | TEXT | `mensual`, `anual`, `null` = sin vencimiento |

### `usuarios`
Usuarios registrados en la plataforma. Autenticación vía OAuth por correo.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `user_id` | UUID (PK) | Identificador único |
| `nombre` | TEXT NOT NULL | Nombre completo |
| `correo_electronico` | TEXT UNIQUE | Correo único (OAuth) |
| `plan_activo` | UUID (FK → planes) | Define los permisos del usuario |
| `estado` | TEXT NOT NULL | `activo`, `inactivo`, `suspendido` |
| `eventos_guardados` | UUID[] | Array de eventos favoritos |
| `enlaces_contacto` | TEXT | Redes sociales u otros medios |
| `fecha_registro` | TIMESTAMPTZ | Timestamp de registro |

### `lugares`
Lugares geográficos donde se realizan los eventos.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `lugar_id` | UUID (PK) | Identificador único |
| `nombre_lugar` | TEXT NOT NULL | Nombre descriptivo del lugar |
| `latitud` | DOUBLE PRECISION | Coordenada latitud (WGS84) |
| `longitud` | DOUBLE PRECISION | Coordenada longitud (WGS84) |
| `estado` | TEXT NOT NULL | `activo`, `inactivo` |
| `fecha_registro` | TIMESTAMPTZ | Timestamp de registro |
| `registrado_por` | UUID (FK → usuarios) | Usuario que registró el lugar |

### `eventos`
Publicaciones de eventos de la plataforma.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `event_id` | UUID (PK) | Identificador único |
| `nombre_evento` | TEXT NOT NULL | Nombre del evento |
| `descripcion_evento` | TEXT | Descripción detallada |
| `fecha_inicio` | TIMESTAMPTZ NOT NULL | Fecha y hora de inicio |
| `fecha_fin` | TIMESTAMPTZ | Fecha y hora de finalización |
| `horarios` | TEXT | Horarios específicos dentro del evento |
| `precio` | NUMERIC(10,2) | Precio de entrada (`0.00` = entrada libre) |
| `imagenes` | TEXT | URLs de ImgBB separadas por coma |
| `lugar_id` | UUID (FK → lugares) | Lugar donde se realiza el evento |
| `estado` | TEXT NOT NULL | `activo`, `cancelado`, `finalizado`, `borrador` |
| `fecha_creacion` | TIMESTAMPTZ | Timestamp de creación |
| `dueno_publicacion` | UUID (FK → usuarios) | Usuario que publicó el evento |

### `pagos`
Historial de pagos de suscripciones por usuario.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `pago_id` | UUID (PK) | Identificador único |
| `user_id` | UUID (FK → usuarios) | Usuario que realizó el pago |
| `plan_id` | UUID (FK → planes) | Plan adquirido |
| `precio_pagado` | NUMERIC(10,2) | Monto real cobrado (con descuento aplicado) |
| `descuento_aplicado` | NUMERIC(5,2) | Porcentaje de descuento en este pago |
| `fecha_pago` | TIMESTAMPTZ | Timestamp del pago |
| `metodo_pago` | TEXT | `tarjeta`, `transferencia`, etc. |
| `estado_pago` | TEXT NOT NULL | `completado`, `pendiente`, `fallido`, `reembolsado` |

---

## Inicialización local

```bash
# Crear la base de datos
createdb geoeventos_db

# Ejecutar los scripts en orden (resuelve dependencias entre FKs)
psql -U alfredo_sanchez -d geoeventos_db -f schema/001_setup.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/002_create_planes.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/004_create_usuarios.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/003_create_lugares.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/005_create_eventos.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/006_create_pagos.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/007_add_fk_lugares_usuario.sql

# (Opcional) Cargar datos de prueba
psql -U alfredo_sanchez -d geoeventos_db -f seeds/008_datos_prueba.sql
```

> **Nota:** El orden `004 → 003` es intencional. `lugares` tiene FK a `usuarios`, por lo que `usuarios` debe existir primero.

---

## Despliegue en Neon

1. Crear un proyecto en [neon.tech](https://neon.tech) y una base de datos llamada `geoeventos`
2. Obtener el connection string desde el dashboard → **Connect**
3. Ejecutar los scripts contra la base de datos remota:

```bash
CONN="postgresql://usuario:password@host.neon.tech/geoeventos?sslmode=require&channel_binding=require"

psql "$CONN" -f schema/001_setup.sql
psql "$CONN" -f schema/002_create_planes.sql
psql "$CONN" -f schema/004_create_usuarios.sql
psql "$CONN" -f schema/003_create_lugares.sql
psql "$CONN" -f schema/005_create_eventos.sql
psql "$CONN" -f schema/006_create_pagos.sql
psql "$CONN" -f schema/007_add_fk_lugares_usuario.sql
```

---

## Flujo de migraciones

Cada cambio estructural debe:

1. Crear un nuevo archivo en `schema/` con el siguiente número secuencial (ej: `009_add_columna_nueva.sql`)
2. Ejecutarlo localmente y verificar que funciona
3. Hacer commit y push al repositorio
4. Ejecutar el script contra Neon

---

## Parte del ecosistema GeoEventos

| Repositorio | Descripción |
|-------------|-------------|
| [GeoEventosAPI](https://github.com/AlfredoSWDev/GeoEventosAPI) | Spring Boot 4 + Java 21 + PostgreSQL |
| [GeoEventosWeb](https://github.com/AlfredoSWDev/GeoEventosWeb) | Kotlin/Wasm + Compose for Web |
| [GeoEventosAndroid](https://github.com/AlfredoSWDev/GeoEventosAndroid) | Kotlin + Jetpack Compose + OSMDroid |
| [GeoEventosDesktop](https://github.com/AlfredoSWDev/GeoEventosDesktop) | Java 23 + JavaFX |
| **GeoEventosDB** | Schema y migraciones PostgreSQL ← aquí |

---

## Autor

**Alfredo Sanchez** — [@AlfredoSWDev](https://github.com/AlfredoSWDev)

📺 Stream de desarrollo en [Twitch](https://twitch.tv/AlfredoSWDev) · [YouTube](https://youtube.com/@AlfredoSWDev)
