# GeoEventosDB 🗺️

Base de datos PostgreSQL de la plataforma **GeoEventos** — sistema B2B de gestión de eventos geolocalizados.

**Administrador:** Alfredo Sanchez  
**Plataforma de producción:** [Neon](https://neon.tech)  
**Motor:** PostgreSQL 15+

---

## Estructura del repositorio

```
GeoEventosDB/
├── schema/
│   ├── 001_create_admin.sql       # Documentación del rol administrador
│   ├── 002_create_lugares.sql     # Tabla de lugares geográficos
│   ├── 003_create_usuarios.sql    # Tabla de usuarios
│   └── 004_create_eventos.sql     # Tabla de eventos
├── seeds/
│   └── datos_prueba.sql           # Datos de prueba (solo desarrollo local)
├── init.sql                       # Script maestro de inicialización
└── README.md
```

---

## Tablas

### `lugares`
Almacena los lugares geográficos donde se realizan los eventos.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `lugar_id` | SERIAL (PK) | Identificador único |
| `nombre_lugar` | TEXT NOT NULL | Nombre descriptivo del lugar |
| `ubicacion_lugar` | TEXT NOT NULL | Dirección o descripción textual |
| `latitud` | DOUBLE PRECISION | Coordenada latitud (WGS84) |
| `longitud` | DOUBLE PRECISION | Coordenada longitud (WGS84) |

### `usuarios`
Almacena los usuarios de la plataforma.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `user_id` | SERIAL (PK) | Identificador único |
| `nombre` | TEXT NOT NULL | Nombre completo |
| `tipo_de_usuario` | TEXT NOT NULL | Rol: `cliente`, `organizador`, `admin` |
| `estado_del_usuario` | TEXT NOT NULL | Estado: `activo`, `inactivo`, `suspendido` |
| `correo_electronico` | TEXT UNIQUE | Correo único del usuario |
| `favoritos` | TEXT | IDs de eventos favoritos |
| `eventos_auspiciados` | TEXT | IDs de eventos auspiciados |

### `eventos`
Almacena los eventos de la plataforma.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `event_id` | SERIAL (PK) | Identificador único |
| `nombre_evento` | TEXT NOT NULL | Nombre del evento |
| `descripcion_evento` | TEXT | Descripción detallada |
| `vigencia_evento` | TEXT | Fecha o rango de vigencia |
| `valor_evento` | TEXT | Precio o valor de entrada |
| `lugar_evento` | TEXT NOT NULL | Nombre o descripción del lugar |
| `fotos_evento` | TEXT | URL de foto (ImgBB) |
| `latitud` | DOUBLE PRECISION | Coordenada latitud (WGS84) |
| `longitud` | DOUBLE PRECISION | Coordenada longitud (WGS84) |

---

## Inicialización local

```bash
# Crear la base de datos
createdb geoeventos_db

# Ejecutar los scripts en orden
psql -U alfredo_sanchez -d geoeventos_db -f schema/002_create_lugares.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/003_create_usuarios.sql
psql -U alfredo_sanchez -d geoeventos_db -f schema/004_create_eventos.sql

# (Opcional) Cargar datos de prueba
psql -U alfredo_sanchez -d geoeventos_db -f seeds/datos_prueba.sql
```

---

## Despliegue en Neon

1. Crear un proyecto en [neon.tech](https://neon.tech) y una base de datos llamada `geoeventos`
2. Obtener el connection string desde el dashboard → **Connect**
3. Ejecutar los scripts contra la base de datos remota:

```bash
CONN="postgresql://usuario:password@host.neon.tech/geoeventos?sslmode=require&channel_binding=require"

psql "$CONN" -f schema/002_create_lugares.sql
psql "$CONN" -f schema/003_create_usuarios.sql
psql "$CONN" -f schema/004_create_eventos.sql
```

---

## Flujo de migraciones

Cada cambio estructural debe:

1. Crear un nuevo archivo en `schema/` con el siguiente número secuencial (ej: `005_add_columna_nueva.sql`)
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
| [GeoEventosDesktop](https://github.com/AlfredoSWDev/GeoEventosDesktop) | Java 23 + Swing + JavaFX |
| **GeoEventosDB** | Schema y migraciones PostgreSQL ← aquí |

---

## Autor

**Alfredo Sanchez** — [@AlfredoSWDev](https://github.com/AlfredoSWDev)

📺 Stream de desarrollo en [Twitch](https://twitch.tv/AlfredoSWDev) · [YouTube](https://youtube.com/@AlfredoSWDev)
