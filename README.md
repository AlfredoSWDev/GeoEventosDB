# GeoEventos DB 🗺️

Base de datos PostgreSQL de la plataforma **GeoEventos** — sistema B2B de gestión de eventos geolocalizados.

**Administrador:** Alfredo Sanchez · alfredosanchez.dev@gmail.com  
**Plataforma de producción:** [Render](https://render.com)  
**Motor:** PostgreSQL 15+

---

## Estructura del repositorio

```
geoeventos-db/
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

| Columna          | Tipo             | Descripción                        |
|------------------|------------------|------------------------------------|
| `lugar_id`       | SERIAL (PK)      | Identificador único                |
| `nombre_lugar`   | TEXT NOT NULL    | Nombre descriptivo del lugar       |
| `ubicacion_lugar`| TEXT NOT NULL    | Dirección o descripción textual    |
| `latitud`        | DOUBLE PRECISION | Coordenada latitud (WGS84)         |
| `longitud`       | DOUBLE PRECISION | Coordenada longitud (WGS84)        |

### `usuarios`
Almacena los usuarios de la plataforma.

| Columna               | Tipo          | Descripción                                      |
|-----------------------|---------------|--------------------------------------------------|
| `user_id`             | SERIAL (PK)   | Identificador único                              |
| `nombre`              | TEXT NOT NULL | Nombre completo del usuario                      |
| `tipo_de_usuario`     | TEXT NOT NULL | Rol: `cliente`, `organizador`, `admin`           |
| `estado_del_usuario`  | TEXT NOT NULL | Estado: `activo`, `inactivo`, `suspendido`       |
| `correo_electronico`  | TEXT UNIQUE   | Correo único del usuario                         |
| `favoritos`           | TEXT          | IDs de eventos favoritos                         |
| `eventos_auspiciados` | TEXT          | IDs de eventos auspiciados                       |

### `eventos`
Almacena los eventos de la plataforma.

| Columna               | Tipo             | Descripción                         |
|-----------------------|------------------|-------------------------------------|
| `event_id`            | SERIAL (PK)      | Identificador único                 |
| `nombre_evento`       | TEXT NOT NULL    | Nombre del evento                   |
| `descripcion_evento`  | TEXT             | Descripción detallada               |
| `vigencia_evento`     | TEXT             | Fecha o rango de vigencia           |
| `valor_evento`        | TEXT             | Precio o valor de entrada           |
| `lugar_evento`        | TEXT NOT NULL    | Nombre o descripción del lugar      |
| `fotos_evento`        | TEXT             | URL o referencia de fotos           |
| `latitud`             | DOUBLE PRECISION | Coordenada latitud (WGS84)          |
| `longitud`            | DOUBLE PRECISION | Coordenada longitud (WGS84)         |

---

## Inicialización local

```bash
# Crear la base de datos
createdb geoeventos_db

# Ejecutar el script maestro
psql -U alfredo_sanchez -d geoeventos_db -f init.sql

# (Opcional) Cargar datos de prueba
psql -U alfredo_sanchez -d geoeventos_db -f seeds/datos_prueba.sql
```

---

## Despliegue en Render

1. Crear una base de datos PostgreSQL en [render.com](https://render.com/docs/databases)
2. Copiar la **External Database URL** desde el dashboard de Render
3. Ejecutar el script maestro contra la base de datos remota:

```bash
psql <RENDER_DATABASE_URL> -f init.sql
```

4. Conectar desde DataGrip usando la External Database URL de Render.

---

## Flujo de trabajo (migraciones)

Cada cambio a la estructura de la base de datos debe:

1. Crear un nuevo archivo en `schema/` con el siguiente número secuencial (ej: `005_add_columna_nueva.sql`)
2. Ejecutarlo localmente y verificar que funciona
3. Hacer commit y push al repositorio
4. Ejecutar el script en Render

---

## Parte del ecosistema GeoEventos

| Repositorio         | Descripción                              |
|---------------------|------------------------------------------|
| [GeoEventosAPI]()   | Spring Boot 4 + Java 25 + PostgreSQL     |
| [GeoEventosWeb]()   | Kotlin Multiplatform / Compose for Web   |
| [GeoEventosAndroid]()| Kotlin + Jetpack Compose + OSMDroid    |
| [GeoEventosGUI]()   | Java 23 + Swing + JavaFX                 |
| **GeoEventosDB**    | Schema y migraciones PostgreSQL ← aquí  |
