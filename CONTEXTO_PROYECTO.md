# Contexto del Proyecto — Liga Deportiva Barrial

**Repositorio:** https://github.com/lams1474/liga_deportiva_app
**Rama:** main
**Último commit:** "feat: semana 14 - cámara, ubicación, permisos y degradación elegante"
**Fecha de actualización:** 20 de septiembre de 2026

---

## Descripción general

Proyecto integrador de Aplicaciones Móviles. App para la Liga Deportiva Barrial José Ignacio Izurieta. Arquitectura cliente-servidor con Flutter (frontend) + Node.js/Express + Prisma + MySQL (backend).

---

## Tecnologías

- **Frontend:** Flutter 3.44.6, Dart 3.12.2, Provider, Dio, sqflite, flutter_secure_storage, connectivity_plus, image_picker, geolocator, permission_handler
- **Backend:** Node.js, TypeScript, Express 5, Prisma ORM 6, JWT, bcryptjs
- **Base de datos:** MySQL 8 en Docker

---

## Estado actual (todo funciona)

- ✅ Login con JWT
- ✅ CRUD Clubes (nombre, ciudad, presidente, fechaFundacion, latitud, longitud, precisionUbicacion)
- ✅ CRUD Jugadores (cédula, nombre, ciudad, fechaNacimiento, idClub, fotoPath)
- ✅ Persistencia offline con sqflite + cola de operaciones pendientes
- ✅ Sincronización automática con backoff exponencial
- ✅ Interceptores Dio (Auth, Refresh, Log, Error)
- ✅ Cámara integrada en formulario jugador (image_picker)
- ✅ Ubicación integrada en formulario club (geolocator)
- ✅ Permisos declarados en Android + iOS
- ✅ Degradación elegante de los 4 estados de permiso
- ✅ BackendChecker para verificar si el backend responde
- ✅ APK compila e instala en dispositivo físico (Infinix X6827, Android 14)

---

## Semanas completadas

- **Semana 12:** Persistencia local + sincronización offline
- **Semana 13:** Interceptores Dio (Auth, Refresh, Log, Error)
- **Semana 14:** Funcionalidades nativas (cámara + ubicación) con degradación elegante

---

## Módulos implementados

| # | Módulo | Endpoint | Estado |
|---|---|---|---|
| 1 | Autenticación JWT | `/api/auth/login` | ✅ |
| 2 | Clubes | `/api/clubes` | ✅ |
| 3 | Jugadores | `/api/jugadores` | ✅ |
| 4 | Disciplinas | `/api/disciplinas` | ✅ |
| 5 | Categorías | `/api/categorias` | ✅ |
| 6 | Árbitros | `/api/arbitros` | ✅ |
| 7 | Temporadas | `/api/temporadas` | ✅ |
| 8 | Partidos | `/api/partidos` | ✅ |
| 9 | Resultados | `/api/resultados` | ✅ |
| 10 | Tabla de posiciones | `/api/tabla-posiciones` | ✅ **con cálculo automático** |

---
### Funcionalidades avanzadas

- ✅ Persistencia offline con sqflite + cola de operaciones pendientes
- ✅ Sincronización automática con backoff exponencial (2s → 32s)
- ✅ 4 interceptores Dio (Auth, Refresh, Log, Error)
- ✅ Cámara integrada en formulario jugador (image_picker)
- ✅ Ubicación integrada en formulario club (geolocator)
- ✅ Permisos declarados en Android + iOS
- ✅ Degradación elegante de los 4 estados de permiso
- ✅ `BackendChecker` para verificar si el backend responde
- ✅ **Cálculo automático de Tabla de posiciones** desde resultados
- ✅ **Worker en backend** que recalcula al crear/editar/eliminar resultados
- ✅ APK compila e instala en dispositivo físico (Infinix X6827, Android 14)

---
## 📊 Lógica de cálculo de la Tabla de posiciones

Al crear/editar/eliminar un resultado, el **worker del backend** recalcula automáticamente:

| Estadística | Regla |
|---|---|
| **PJ** (Partidos Jugados) | +1 por cada partido con resultado |
| **PG** (Ganados) | +1 si marcador_local > marcador_visitante |
| **PE** (Empatados) | +1 si marcador_local == marcador_visitante |
| **PP** (Perdidos) | +1 si marcador_local < marcador_visitante |
| **GF** (Goles a Favor) | Suma de goles anotados |
| **GC** (Goles en Contra) | Suma de goles recibidos |
| **Puntos** | `(PG * 3) + (PE * 1)` |

**Ventaja:** La tabla siempre está actualizada. No hay que crearla manualmente.
---

## 📁 Estructura de archivos clave

### Frontend (`frontend/lib/`)

**Configuración:**
- `config/api_config.dart` → IP del backend (actualizar si cambia)

**Servicios:**
- `services/permission_service.dart` → enum `PermissionResult`
- `services/backend_checker.dart` → verifica si el backend responde
- `services/foto_service.dart` → copia foto a directorio permanente
- `services/connectivity_service.dart` → ping al backend
- `services/dio_config.dart` → 4 interceptores
- `services/auth_service.dart`, `club_service.dart`, `jugador_service.dart`, `disciplina_service.dart`, `categoria_service.dart`, `arbitro_service.dart`, `temporada_service.dart`, `partido_service.dart`, `resultado_service.dart`, `tabla_posiciones_service.dart`

**Providers:**
- `providers/auth_provider.dart` → guarda/restaura usuario completo con rol
- `providers/connectivity_provider.dart` → método `refresh()` devuelve `Future<bool>`
- `providers/sync_provider.dart`
- `providers/club_provider.dart`, `jugador_provider.dart`, `disciplina_provider.dart`, `categoria_provider.dart`, `arbitro_provider.dart`, `temporada_provider.dart`, `partido_provider.dart`, `resultado_provider.dart`, `tabla_posiciones_provider.dart`

**Base de datos local (BD v8):**
- `database/database_helper.dart` → tablas: clubes, jugadores, disciplinas, categorias, arbitros, temporadas, partidos, resultados, tabla_posiciones, operaciones_pendientes
- `database/app_dao.dart`

**Pantallas:**
- `screens/auth/login_screen.dart`
- `screens/dashboard/dashboard_screen.dart` (9 cards)
- `screens/clubes/clubes_screen.dart`, `crear_club_screen.dart`, `editar_club_screen.dart`
- `screens/jugadores/jugadores_screen.dart`, `editar_jugador_screen.dart`
- `screens/disciplinas/disciplinas_screen.dart`
- `screens/categorias/categorias_screen.dart`
- `screens/arbitros/arbitros_screen.dart`
- `screens/temporadas/temporadas_screen.dart`
- `screens/partidos/partidos_screen.dart`
- `screens/resultados/resultados_screen.dart`
- `screens/tabla_posiciones/tabla_posiciones_screen.dart`

**Modelos:**
- `models/usuario.dart`, `login_response.dart`, `club.dart`, `jugador.dart`, `disciplina.dart`, `categoria.dart`, `arbitro.dart`, `temporada.dart`, `partido.dart`, `resultado.dart`, `tabla_posiciones.dart`

### Backend (`backend/src/`)

**Controllers, Services, Repositories:** uno por cada módulo

**Workers:**
- `workers/resultado.worker.ts` → 🔥 **Recalcula la tabla de posiciones automáticamente** al crear/editar/eliminar resultados

**Middlewares:**
- `middlewares/auth.middleware.ts` → verifica JWT
- `middlewares/rol.middleware.ts` → verifica roles

**Config:**
- `config/prisma.ts` → cliente Prisma
- `config/swagger.ts` → configuración de Swagger

### Prisma (`backend/prisma/schema.prisma`)

Modelos: `Usuario`, `Club`, `Jugador`, `Disciplina`, `Categoria`, `Temporada`, `Arbitro`, `Partido`, `Resultado`, `TablaPosiciones`, `JugadorDisciplina`

---

## ⚠️ Problemas conocidos (comportamiento normal)

1. **Android reinicia la app** al cambiar un permiso desde Ajustes. Es normal del sistema operativo.
2. **La IP de la PC cambia** (DHCP). Si es así, actualizar `api_config.dart`.
3. **El backend NO extrae `programado_por` / `registrado_por` del JWT.** El frontend los envía en el body desde `AuthProvider.usuario.idUsuario`.
4. **El worker tarda ~2 segundos** en recalcular la tabla. Esperar antes de abrir la pantalla.
5. **Docker no arranca automáticamente** al reiniciar Windows. Hay que levantarlo cada vez.
---

## Cómo correr el proyecto

### Terminal 1: Backend

```powershell
cd backend
npm run dev
Debe decir: Servidor corriendo en http://0.0.0.0:3000

## Terminal 2: Frontend
cd frontend
flutter run -d <device-id> // chomen etc. O
flutter run -d 09225372BB004945

Verificar IP en lib/config/api_config.dart.

🔑 Credenciales de prueba
Correo: admin@liga.com
Contraseña: 654321
Rol: SUPER_ADMIN

## Comandos útiles
powershell
# Regenerar .g.dart después de cambiar modelos
cd frontend
dart run build_runner build --delete-conflicting-outputs

# Migrar BD Prisma (después de cambiar schema.prisma)
cd backend
npx prisma migrate dev --name <nombre>
npx prisma generate

# Ver IP de la PC
ipconfig

# Ver dispositivos conectados
adb devices

# Instalar APK en celular
flutter install

# Levantar MySQL si está apagado
cd backend
docker-compose up -d

# Migrar BD Prisma (después de cambiar schema.prisma)
cd backend
npx prisma migrate dev --name <nombre>
npx prisma generate

# Desinstalar app del celular
adb uninstall com.example.frontend

# Instalar APK en celular
flutter install

## Semana 15
Pruebas y documentación

Considerar implementar JugadorDisciplina (relación N:M entre jugadores y disciplinas)

## Semana 16
Despliegue

## 🔄 Orden lógico de los módulos (si se reinicia el proyecto)
Disciplinas

Categorías (depende de Disciplinas)

Árbitros

Temporadas

Clubes

Jugadores (depende de Clubes)

Partidos (depende de Categoría, 2 Clubes, Temporada, Árbitro, Usuario)

Resultados (depende de Partido, Usuario)

Tabla de posiciones (se calcula automáticamente desde Resultados)

## 💬 Lo que necesito en el nuevo chat
[DESCRIBE AQUÍ LO QUE QUIERES HACER EN LA PRÓXIMA SESIÓN]

Ejemplos:

"Quiero grabar el video de la Semana 14"

"Quiero hacer pruebas automatizadas para la Semana 15"

"Quiero implementar el módulo de JugadorDisciplina"

"Quiero agregar autenticación con Google"

"Quiero desplegar el backend en la nube"
