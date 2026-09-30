# Catálogo de Endpoints — API Liga Deportiva Barrial

**Base URL:** `http://192.168.0.106:3000`
**Swagger UI:** `http://192.168.0.106:3000/api-docs`
**Health Check:** `http://192.168.0.106:3000/health`

---

## 📋 Índice

1. [Autenticación](#1-autenticación)
2. [Usuarios](#2-usuarios)
3. [Clubes](#3-clubes)
4. [Jugadores](#4-jugadores)
5. [Disciplinas](#5-disciplinas)
6. [Categorías](#6-categorías)
7. [Árbitros](#7-árbitros)
8. [Temporadas](#8-temporadas)
9. [Partidos](#9-partidos)
10. [Resultados](#10-resultados)
11. [Tabla de Posiciones](#11-tabla-de-posiciones)
12. [Jugador-Disciplina](#12-jugador-disciplina)
13. [Sistema](#13-sistema)

---

## 1. Autenticación

### POST `/api/auth/login`

Inicia sesión y devuelve un token JWT.

- **Auth:** No requiere
- **Body:**

  {
  "correo": "admin@liga.com",
  "contrasena": "654321"
  }

- **Response 200:**

  {
  "mensaje": "Inicio de sesión exitoso.",
  "token": "eyJhbGciOi...",
  "refreshToken": "eyJhbGciOi...",
  "usuario": {
  "id_usuario": 1,
  "nombre": "Administrador General",
  "correo": "admin@liga.com",
  "rol": "SUPER_ADMIN"
  }
  }

- **Errores:** `400` (faltan campos), `401` (credenciales inválidas)

### POST `/api/auth/refresh`

Renueva el access token usando el refresh token.

- **Auth:** No requiere
- **Body:**

  {
  "refreshToken": "eyJhbGciOi..."
  }

- **Response 200:**

  {
  "mensaje": "Token renovado exitosamente.",
  "token": "eyJhbGciOi..."
  }

- **Errores:** `400` (falta refreshToken), `401` (refresh inválido/expirado)

---

## 2. Usuarios

> Todos los endpoints requieren `Authorization: Bearer <token>`

### GET `/api/usuarios`

Lista todos los usuarios (sin contraseñas).

- **Auth:** Si
- **Rol:** Cualquier usuario autenticado
- **Response 200:**

  [
  {
  "id_usuario": 1,
  "nombre": "Administrador General",
  "correo": "admin@liga.com",
  "rol": "SUPER_ADMIN"
  }
  ]

### GET `/api/usuarios/:id`

Obtiene un usuario por ID.

- **Auth:** Si
- **Rol:** Cualquier usuario autenticado
- **Params:** `id` (integer)
- **Errores:** `404` (no encontrado)

### POST `/api/usuarios`

Crea un usuario nuevo.

- **Auth:** Si
- **Rol:** `SUPER_ADMIN`
- **Body:**

  {
  "nombre": "Juan Pérez",
  "correo": "juan@liga.com",
  "contrasena": "MiPassword123!",
  "rol": "ADMIN"
  }

- **Errores:** `400`, `401`, `403`

### PUT `/api/usuarios/:id`

Actualiza un usuario.

- **Auth:** Si
- **Rol:** `SUPER_ADMIN`
- **Body:** Mismos campos que POST (opcionales)
- **Errores:** `400`, `401`, `403`, `404`

### DELETE `/api/usuarios/:id`

Elimina un usuario.

- **Auth:** Si
- **Rol:** `SUPER_ADMIN`
- **Errores:** `401`, `403`, `404`

---

## 3. Clubes

### GET `/api/clubes`

Lista todos los clubes.

- **Auth:** No
- **Response 200:**

  [
  {
  "id_club": 1,
  "nombre": "Club Deportivo Spartanos FC",
  "ciudad": "Pujilí",
  "presidente": "Luis Maigua",
  "fecha_fundacion": "2012-05-05T00:00:00.000Z",
  "latitud": -0.9566143,
  "longitud": -78.68988,
  "precision_ubicacion": "aproximada"
  }
  ]

### GET `/api/clubes/:id`

Obtiene un club por ID.

- **Auth:** No

### POST `/api/clubes`

Crea un club.

- **Auth:** No
- **Body:**

  {
  "nombre": "Nuevo Club",
  "ciudad": "Quito",
  "presidente": "Pedro Gómez",
  "fecha_fundacion": "2020-01-15",
  "latitud": -0.22,
  "longitud": -78.5,
  "precision_ubicacion": "precisa"
  }

- **Errores:** `422` (nombre duplicado), `400`

### PUT `/api/clubes/:id`

Actualiza un club.

- **Auth:** No

### DELETE `/api/clubes/:id`

Elimina un club.

- **Auth:** No

---

## 4. Jugadores

### GET `/api/jugadores`

Lista todos los jugadores.

- **Auth:** No
- **Response 200:**

  [
  {
  "id_jugador": 1,
  "cedula": "1234567890",
  "nombre": "Juan Pérez",
  "ciudad": "Quito",
  "fecha_nacimiento": "2005-03-15T00:00:00.000Z",
  "id_club": 1,
  "foto_path": "/data/.../jugador_xxx.jpg",
  "club": { "id_club": 1, "nombre": "..." }
  }
  ]

### GET `/api/jugadores/:id`

Obtiene un jugador por ID.

- **Auth:** No

### POST `/api/jugadores`

Crea un jugador.

- **Auth:** No
- **Body:**

  {
  "cedula": "1234567890",
  "nombre": "Juan Pérez",
  "ciudad": "Quito",
  "fecha_nacimiento": "2005-03-15",
  "id_club": 1,
  "foto_path": "/data/.../foto.jpg"
  }

- **Errores:** `422` (cédula duplicada), `400`

### PUT `/api/jugadores/:id`

Actualiza un jugador.

- **Auth:** No

### DELETE `/api/jugadores/:id`

Elimina un jugador.

- **Auth:** No

---

## 5. Disciplinas

### GET `/api/disciplinas`

Lista todas las disciplinas.

- **Auth:** No

### GET `/api/disciplinas/:id`

Obtiene una disciplina por ID.

- **Auth:** No

### POST `/api/disciplinas`

Crea una disciplina.

- **Auth:** No
- **Body:**

  {
  "nombre": "Fútbol"
  }

- **Errores:** `400` (nombre duplicado)

### PUT `/api/disciplinas/:id`

Actualiza una disciplina.

- **Auth:** No

### DELETE `/api/disciplinas/:id`

Elimina una disciplina.

- **Auth:** No

---

## 6. Categorías

### GET `/api/categorias`

Lista todas las categorías (con su disciplina incluida).

- **Auth:** No
- **Response 200:**

  [
  {
  "id_categoria": 1,
  "nombre": "Sub-15",
  "id_disciplina": 1,
  "disciplina": { "id_disciplina": 1, "nombre": "Fútbol" }
  }
  ]

### GET `/api/categorias/:id`

Obtiene una categoría por ID.

- **Auth:** No

### POST `/api/categorias`

Crea una categoría.

- **Auth:** No
- **Body:**

  {
  "nombre": "Sub-15",
  "id_disciplina": 1
  }

### PUT `/api/categorias/:id`

Actualiza una categoría.

- **Auth:** No

### DELETE `/api/categorias/:id`

Elimina una categoría.

- **Auth:** No

---

## 7. Árbitros

### GET `/api/arbitros`

Lista todos los árbitros.

- **Auth:** No

### GET `/api/arbitros/:id`

Obtiene un árbitro por ID.

- **Auth:** No

### POST `/api/arbitros`

Crea un árbitro.

- **Auth:** No
- **Body:**

  {
  "nombre": "Juan Rodríguez",
  "categoria": "FIFA"
  }

### PUT `/api/arbitros/:id`

Actualiza un árbitro.

- **Auth:** No

### DELETE `/api/arbitros/:id`

Elimina un árbitro.

- **Auth:** No

---

## 8. Temporadas

### GET `/api/temporadas`

Lista todas las temporadas.

- **Auth:** No

### GET `/api/temporadas/:id`

Obtiene una temporada por ID.

- **Auth:** No

### POST `/api/temporadas`

Crea una temporada.

- **Auth:** No
- **Body:**

  {
  "año": 2026
  }

- **Errores:** `400` (año duplicado)

### PUT `/api/temporadas/:id`

Actualiza una temporada.

- **Auth:** No

### DELETE `/api/temporadas/:id`

Elimina una temporada.

- **Auth:** No

---

## 9. Partidos

### GET `/api/partidos`

Lista todos los partidos (con relaciones incluidas).

- **Auth:** No
- **Response 200:**

  [
  {
  "id_partido": 1,
  "fecha": "2026-10-15T00:00:00.000Z",
  "hora": "15:30",
  "lugar": "Estadio Central",
  "id_categoria": 1,
  "id_club_local": 1,
  "id_club_visitante": 2,
  "id_temporada": 1,
  "id_arbitro": 1,
  "programado_por": 1,
  "categoria": { "..." },
  "club_local": { "..." },
  "club_visitante": { "..." },
  "temporada": { "..." },
  "arbitro": { "..." },
  "programador": { "id_usuario": 1, "nombre": "Admin" },
  "resultado": null
  }
  ]

### GET `/api/partidos/:id`

Obtiene un partido por ID.

- **Auth:** No

### POST `/api/partidos`

Crea un partido.

- **Auth:** No
- **Body:**

  {
  "fecha": "2026-10-15",
  "hora": "15:30",
  "lugar": "Estadio Central",
  "id_categoria": 1,
  "id_club_local": 1,
  "id_club_visitante": 2,
  "id_temporada": 1,
  "id_arbitro": 1,
  "programado_por": 1
  }

- **Errores:** `400` (club_local igual a club_visitante)

### PUT `/api/partidos/:id`

Actualiza un partido.

- **Auth:** No

### DELETE `/api/partidos/:id`

Elimina un partido.

- **Auth:** No

---

## 10. Resultados

### GET `/api/resultados`

Lista todos los resultados (con partido y registrador).

- **Auth:** No
- **Response 200:**

  [
  {
  "id_resultado": 1,
  "id_partido": 1,
  "marcador_local": 2,
  "marcador_visitante": 1,
  "registrado_por": 1,
  "partido": { "..." },
  "registrador": { "..." }
  }
  ]

### GET `/api/resultados/:id`

Obtiene un resultado por ID.

- **Auth:** No

### POST `/api/resultados`

Crea un resultado. Dispara el worker que recalcula la tabla de posiciones.

- **Auth:** No
- **Body:**

  {
  "id_partido": 1,
  "marcador_local": 2,
  "marcador_visitante": 1,
  "registrado_por": 1
  }

- **Errores:** `400` (resultado ya existe para ese partido)

### PUT `/api/resultados/:id`

Actualiza un resultado. Dispara el worker.

- **Auth:** No

### DELETE `/api/resultados/:id`

Elimina un resultado. Dispara el worker.

- **Auth:** No

---

## 11. Tabla de Posiciones

### GET `/api/tabla-posiciones`

Lista la tabla de posiciones ordenada por puntos desc.

- **Auth:** No
- **Response 200:**

  [
  {
  "id_posicion": 1,
  "id_temporada": 1,
  "id_club": 1,
  "puntos": 6,
  "pj": 2,
  "pg": 2,
  "pe": 0,
  "pp": 0,
  "gf": 4,
  "gc": 1,
  "temporada": { "id_temporada": 1, "año": 2026 },
  "club": { "id_club": 1, "nombre": "..." }
  }
  ]

- **Nota:** Se calcula automáticamente desde `Resultado` mediante el worker.

### GET `/api/tabla-posiciones/:id`

Obtiene un registro por ID.

- **Auth:** No

### POST `/api/tabla-posiciones`

Crea un registro manualmente (normalmente no se usa porque el worker lo hace).

- **Auth:** No

### PUT `/api/tabla-posiciones/:id`

Actualiza un registro manualmente.

- **Auth:** No

### DELETE `/api/tabla-posiciones/:id`

Elimina un registro.

- **Auth:** No

---

## 12. Jugador-Disciplina

> Relación N:M entre jugadores y disciplinas.

### GET `/api/jugador-disciplina`

Lista todas las relaciones.

- **Auth:** No

### POST `/api/jugador-disciplina`

Crea una relación.

- **Auth:** No
- **Body:**

  {
  "id_jugador": 1,
  "id_disciplina": 1
  }

### DELETE `/api/jugador-disciplina`

Elimina una relación.

- **Auth:** No
- **Body:**

  {
  "id_jugador": 1,
  "id_disciplina": 1
  }

---

## 13. Sistema

### GET `/health`

Health check del servidor.

- **Auth:** No
- **Response 200:**

  {
  "status": "OK",
  "message": "Servidor funcionando correctamente",
  "timestamp": "2026-09-30T05:23:18.000Z"
  }

### GET `/api-docs`

Documentación Swagger UI interactiva.

- **Auth:** No

### GET `/`

Mensaje de bienvenida.

- **Auth:** No
- **Response:** `"API Liga Deportiva Barrial José Ignacio Izurieta"`

---

## Roles del sistema

| Rol           | Permisos                                   |
| ------------- | ------------------------------------------ |
| `SUPER_ADMIN` | Acceso total (incluye gestión de usuarios) |
| `ADMIN`       | Acceso a CRUDs excepto usuarios            |
| `USER`        | Acceso de solo lectura (si se implementa)  |

---

## Notas importantes

1. La mayoría de endpoints NO validan token. Solo `usuarios` lo hace. Considerar agregar `verificarToken` a todos en la Semana 15.
2. `programado_por` y `registrado_por` se envían desde el frontend (no se extraen del JWT).
3. La tabla de posiciones se recalcula automáticamente cuando se crea/edita/elimina un resultado (worker).
4. El access token expira en 15 minutos, el refresh token en 7 días.
5. Los errores de validación devuelven 422 con estructura `{ mensaje, errores: [{campo, mensaje}] }`.

---

## Códigos de respuesta comunes

| Código | Significado                   |
| ------ | ----------------------------- |
| `200`  | OK                            |
| `201`  | Creado                        |
| `400`  | Bad Request (datos inválidos) |
| `401`  | No autenticado                |
| `403`  | Sin permisos                  |
| `404`  | No encontrado                 |
| `422`  | Validación fallida            |
| `500`  | Error del servidor            |
