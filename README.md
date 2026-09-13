# Liga Deportiva Barrial José Ignacio Izurieta

Proyecto integrador de la asignatura **Aplicaciones Móviles**.

La aplicación tiene como objetivo apoyar la gestión de la Liga Deportiva Barrial José Ignacio Izurieta mediante una arquitectura cliente-servidor. El frontend móvil multiplataforma está desarrollado con Flutter y consume los servicios REST proporcionados por el backend.

---

## 📋 Índice

1. [Tecnologías utilizadas](#1-tecnologías-utilizadas)
2. [Arquitectura](#2-arquitectura)
3. [Framework seleccionado](#3-framework-seleccionado)
4. [Características del entorno](#4-características-del-entorno)
5. [Verificación de Flutter](#5-verificación-de-flutter)
6. [Estructura principal del proyecto](#6-estructura-principal-del-proyecto)
7. [Ejecución del frontend](#7-ejecución-del-frontend)
8. [Recarga en caliente](#8-recarga-en-caliente)
9. [Backend](#9-backend)
10. [Configuración de la API](#10-configuración-de-la-api)
11. [Autenticación y comunicación con la API](#11-autenticación-y-comunicación-con-la-api)
12. [Dependencias principales del frontend](#12-dependencias-principales-del-frontend)
13. [Base de datos](#13-base-de-datos)
14. [Verificación de conectividad](#14-verificación-de-conectividad)
15. [Persistencia local y almacenamiento seguro](#15-persistencia-local-y-almacenamiento-seguro)
16. [Sincronización sin conexión](#16-sincronización-sin-conexión)
17. [Módulos implementados](#17-módulos-implementados)
18. [Limitaciones del entorno](#18-limitaciones-del-entorno)
19. [Control de versiones](#19-control-de-versiones)
20. [Reproducción básica del entorno](#20-reproducción-básica-del-entorno)
21. [Estado del proyecto](#21-estado-del-proyecto)
22. [Conclusión](#22-conclusión)

---

## 1. Tecnologías utilizadas

### Frontend

| Tecnología | Versión | Uso |
|------------|---------|-----|
| Flutter | 3.44.6 | Framework multiplataforma |
| Dart | 3.12.2 | Lenguaje de programación |
| Provider | ^6.1.5+1 | Manejo de estado |
| Dio | ^5.11.0 | Cliente HTTP |
| flutter_secure_storage | ^10.3.1 | Almacenamiento seguro de tokens |
| shared_preferences | ^2.5.5 | Preferencias de usuario |
| sqflite | ^2.4.0 | Base de datos local |
| connectivity_plus | ^6.1.3 | Detección de conectividad |
| intl | ^0.19.0 | Formato de fechas |
| jwt_decoder | ^2.0.1 | Decodificación de JWT |
| DevTools | 2.57.0 | Herramientas de desarrollo |

### Backend

| Tecnología | Versión | Uso |
|------------|---------|-----|
| Node.js | - | Entorno de ejecución |
| TypeScript | ^7.0.2 | Lenguaje de programación |
| Express | ^5.2.1 | Framework web |
| Prisma ORM | ^6.19.0 | ORM para base de datos |
| JWT | ^9.0.3 | Autenticación |
| bcryptjs | ^3.0.3 | Hash de contraseñas |
| Helmet | ^8.3.0 | Seguridad HTTP |
| Morgan | ^1.11.0 | Logging de solicitudes |
| Cors | ^2.8.6 | CORS |

### Base de datos

| Tecnología | Versión | Uso |
|------------|---------|-----|
| MySQL | 8 | Base de datos relacional |
| Docker | - | Contenedorización |

### Herramientas de desarrollo

| Herramienta | Uso |
|-------------|-----|
| Visual Studio Code | Editor de código |
| Android Studio | IDE para Android |
| Google Chrome | Destino de ejecución |
| Git | Control de versiones |
| GitHub | Repositorio remoto |
| Postman/Insomnia | Pruebas de API |

---

## 2. Arquitectura

El proyecto utiliza una arquitectura **cliente-servidor** con capas bien definidas:

```text
┌─────────────────────────────────────────────────────────────┐
│                    Aplicación Flutter                       │
│                     (Frontend)                              │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │  Providers  │  │   Services (Dio)    │ │
│  │  (UI/UX)    │──│  (Estado)   │──│   (HTTP Client)     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│                                            │                │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Almacenamiento Local                   │    │
│  │  ┌──────────────┐  ┌────────────────────────────┐  │    │
│  │  │ Secure Store │  │  SQLite (sqflite)          │  │    │
│  │  │ (Tokens)     │  │  (Clubes, Jugadores,       │  │    │
│  │  │              │  │   Operaciones Pendientes)  │  │    │
│  │  └──────────────┘  └────────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                            │                │
└────────────────────────────────────────────┼────────────────┘
                                             │
                                             │ HTTP / REST
                                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      API REST Backend                       │
│                    Node.js / Express                        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Controllers │  │  Services   │  │   Middlewares       │ │
│  │ (Rutas)     │──│ (Lógica)    │──│ (Auth, Roles, CORS) │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│                                            │                │
└────────────────────────────────────────────┼────────────────┘
                                             │
                                             │ Prisma ORM
                                             ▼
┌─────────────────────────────────────────────────────────────┐
│                        MySQL 8                             │
│                        Docker                              │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Usuario │ Club │ Jugador │ Disciplina │ Categoria │    │
│  │  Partido │ Arbitro │ Resultado │ TablaPosiciones │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
---
## 3. Framework seleccionado
Se seleccionó Flutter como framework multiplataforma porque permite desarrollar aplicaciones para diferentes plataformas utilizando una única base de código.

Para este proyecto, Flutter permite trabajar con Dart y facilita el desarrollo de la interfaz, la integración con servicios HTTP y la ejecución durante las etapas de desarrollo mediante recarga en caliente.

---
## 4. Características del entorno

El entorno utilizado para el desarrollo corresponde a:

| Componente | Especificación |
|------------|----------------|
| Sistema operativo | Windows 11 Pro 64 bits |
| Versión de Windows | 23H2 |
| Procesador | AMD Ryzen 3 3250U |
| Memoria RAM | 4 GB |
| Flutter | 3.44.6 |
| Dart | 3.12.2 |
| DevTools | 2.57.0 |
| Android SDK | 36.1.0 |
| Build Tools | 36.1.0 |
| Java | OpenJDK 21.0.10 |
| Navegador destino | Google Chrome |

---
## 5. Verificación de Flutter
Para comprobar la versión instalada se utiliza:

powershell
flutter --version
Para realizar el diagnóstico completo del entorno:

powershell
flutter doctor -v
Para verificar los destinos disponibles:

powershell
flutter devices
El diagnóstico permitió comprobar que Flutter, Windows, Android Toolchain, Chrome y los recursos de red se encuentran disponibles.

Durante el diagnóstico se identificó que Visual Studio no está instalado para el desarrollo de aplicaciones Windows. Esta herramienta no fue necesaria para la demostración realizada, debido a que el destino seleccionado fue Chrome.

---
## 6. Estructura principal del proyecto
text
liga_deportiva_app/
│
├── backend/
│   ├── prisma/
│   │   ├── migrations/
│   │   ├── schema.prisma
│   │   └── seed.ts
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── generated/
│   │   ├── middlewares/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── app.ts
│   │   └── server.ts
│   ├── .env
│   ├── package.json
│   ├── tsconfig.json
│   └── docker-compose.yml
│
├── frontend/
│   ├── lib/
│   │   ├── config/
│   │   ├── database/
│   │   │   ├── database_helper.dart
│   │   │   └── app_dao.dart
│   │   ├── forms/
│   │   ├── models/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── club_provider.dart
│   │   │   ├── jugador_provider.dart
│   │   │   ├── connectivity_provider.dart
│   │   │   └── sync_provider.dart
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   ├── clubes/
│   │   │   ├── dashboard/
│   │   │   └── jugadores/
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── club_service.dart
│   │   │   ├── jugador_service.dart
│   │   │   ├── connectivity_service.dart
│   │   │   ├── sync_service.dart
│   │   │   └── dio_config.dart
│   │   ├── theme/
│   │   ├── widgets/
│   │   └── main.dart
│   │
│   ├── android/
│   ├── ios/
│   ├── linux/
│   ├── macos/
│   ├── web/
│   ├── windows/
│   ├── pubspec.yaml
│   └── test/
│
├── docs/
├── .gitignore
└── README.md

---
## 7. Ejecución del frontend
Para ejecutar el proyecto Flutter:

powershell
cd frontend
flutter run -d chrome
También se puede utilizar:

powershell
flutter devices
para consultar los destinos disponibles.

Durante la demostración se utilizó Google Chrome como destino de ejecución.

La elección de Chrome permitió ejecutar y verificar la aplicación utilizando los recursos disponibles del equipo, evitando la carga adicional de un emulador Android.

---
## 8. Recarga en caliente
Flutter permite utilizar Hot Reload durante el desarrollo.

La recarga en caliente permite observar cambios realizados en el código sin tener que reiniciar completamente la aplicación, facilitando el desarrollo y las pruebas de la interfaz.

---
## 9. Backend
El backend se ejecuta mediante Node.js.

Para iniciar el servidor:

powershell
cd backend
npm run dev
El servidor queda disponible en:

text
http://localhost:3000
Para acceso desde otros dispositivos en la misma red, el servidor escucha en 0.0.0.0:

text
http://192.168.x.x:3000
El backend proporciona además un endpoint de comprobación:

text
http://localhost:3000/health
Una respuesta correcta del endpoint es:

json
{
  "status": "OK",
  "message": "Servidor funcionando correctamente",
  "timestamp": "..."
}

---
## 10. Configuración de la API
La URL base utilizada por el frontend se encuentra definida en:

text
frontend/lib/services/dio_config.dart
Configuración utilizada durante el desarrollo:

dart
class DioConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  // Para acceso desde otros dispositivos:
  // static const String baseUrl = 'http://192.168.x.x:3000/api';
}
La dirección localhost corresponde al equipo local donde se encuentra ejecutándose el backend.

Esta configuración corresponde al entorno de desarrollo local y debe modificarse cuando la aplicación se despliegue en un entorno diferente.

---
## 11. Autenticación y comunicación con la API
La aplicación utiliza autenticación para acceder a los recursos protegidos del backend.

El frontend almacena el token de autenticación mediante almacenamiento seguro y lo envía en las solicitudes protegidas mediante el encabezado:

text
Authorization: Bearer <token>
Durante la verificación del entorno se comprobó la autenticación mediante una solicitud:

text
POST /api/auth/login
con respuesta exitosa:

text
200
Posteriormente se verificó el acceso al recurso de clubes mediante:

text
GET /api/clubes
obteniendo una respuesta exitosa:

text
200

Esto permitió comprobar que la aplicación Flutter puede comunicarse correctamente con el backend propio del proyecto.

---
## 12. Dependencias principales del frontend

Entre las dependencias utilizadas se encuentran:

| Paquete | Versión | Función |
|---------|---------|---------|
| `dio` | ^5.11.0 | Cliente HTTP para solicitudes a la API |
| `provider` | ^6.1.5+1 | Administración del estado de la aplicación |
| `flutter_secure_storage` | ^10.3.1 | Almacenamiento seguro del token |
| `sqflite` | ^2.4.0 | Base de datos local SQLite |
| `connectivity_plus` | ^6.1.3 | Detección de conectividad |
| `shared_preferences` | ^2.5.5 | Preferencias de usuario |
| `jwt_decoder` | ^2.0.1 | Decodificación de JWT |

Estas dependencias se encuentran registradas en:

```text
frontend/pubspec.yaml

---
## 13. Base de datos
La aplicación utiliza MySQL 8 como sistema de gestión de base de datos.

La base de datos se ejecuta mediante Docker durante el desarrollo.

El backend utiliza Prisma ORM para interactuar con la base de datos.

Modelos de la base de datos
prisma
model Usuario { ... }
model Club { ... }
model Jugador { ... }
model Disciplina { ... }
model Categoria { ... }
model Temporada { ... }
model Arbitro { ... }
model Partido { ... }
model Resultado { ... }
model TablaPosiciones { ... }
model JugadorDisciplina { ... }
La arquitectura utilizada es:

text
Flutter
   ↓
API REST
   ↓
Prisma ORM
   ↓
MySQL
   ↓
Docker

---
## 14. Verificación de conectividad
La conectividad fue comprobada en dos niveles.

Health Check
text
GET /health
Resultado:

text
200 OK
API protegida
text
POST /api/auth/login
Resultado:

text
200 OK
Posteriormente:

text
GET /api/clubes
Resultado:

text
200 OK
La evidencia confirma que el frontend puede autenticarse y consumir un endpoint del backend propio.

---
## 15. Persistencia local y almacenamiento seguro
### 15.1 Almacenamiento seguro de credenciales
Los tokens de autenticación se almacenan en flutter_secure_storage, que utiliza:

iOS: Keychain (llavero)

Android: Keystore (almacén de claves)

Esto garantiza que los tokens estén cifrados y protegidos contra accesos no autorizados.

dart
// Ejemplo de almacenamiento seguro
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
final token = await storage.read(key: 'token');
await storage.delete(key: 'token'); // Al cerrar sesión

### 15.2 Base de datos local (sqflite)
La aplicación utiliza SQLite como base de datos local con las siguientes tablas:

Tabla	Función
clubes	Almacena clubes localmente
jugadores	Almacena jugadores localmente
operaciones_pendientes	Cola de sincronización

### 15.3 Campos de control de sincronización
Cada tabla incluye campos de control:

Campo	Función
pendiente_envio	Indica si el registro debe sincronizarse
eliminado_local	Indica si fue eliminado localmente
ultima_sincronizacion	Fecha de última sincronización
id_unico_cliente	UUID para idempotencia

---
## 16. Sincronización sin conexión
### 16.1 Estrategia implementada
Se implementó una estrategia de escritura diferida en cola:

Característica	Descripción
Funcionamiento	Los cambios se registran localmente y se encolan
Sincronización	Automática al recuperar conexión
Reintentos	Backoff exponencial (2s, 4s, 8s, 16s, 32s)
Idempotencia	UUID para evitar duplicados

### 16.2 Flujo de sincronización
text
1. Usuario ejecuta acción (crear/editar/eliminar)
   ↓
2. Verificar conectividad
   ↓
3. Si hay conexión → Enviar al servidor
   ↓
4. Si NO hay conexión → Guardar en BD local + Cola
   ↓
5. Al recuperar conexión → Sincronizar automáticamente
   ↓
6. Reintentos con backoff si falla

### 16.3 Reintentos y backoff
Intento	Tiempo de espera
1	2 segundos
2	4 segundos
3	8 segundos
4	16 segundos
5+	32 segundos

---
## 17. Módulos implementados

| Módulo | Estado | Funcionalidades |
|--------|--------|-----------------|
| **Autenticación** | ✅ Completado | Login, logout, token JWT |
| **Clubes** | ✅ Completado | CRUD completo + sincronización offline |
| **Jugadores** | ✅ Completado | CRUD completo + sincronización offline |
| **Disciplinas** | ⏳ Pendiente | - |
| **Categorías** | ⏳ Pendiente | - |
| **Partidos** | ⏳ Pendiente | - |
| **Tabla de posiciones** | ⏳ Pendiente | - |

### Credenciales de prueba

| Campo | Valor |
|-------|-------|
| **Correo** | `admin@liga.com` |
| **Contraseña** | `654321` |

---
## 18. Limitaciones del entorno
Limitación 1: memoria disponible
El equipo dispone de 4 GB de memoria RAM. La ejecución simultánea de Flutter, el backend, Docker y herramientas adicionales puede generar un consumo considerable de recursos.

Como estrategia de mitigación se utilizó Google Chrome como destino de ejecución, evitando depender de un emulador Android durante la demostración.

Limitación 2: desarrollo para Windows
El diagnóstico flutter doctor -v reportó que Visual Studio no está instalado para el desarrollo de aplicaciones Windows.

Esta limitación no afecta la demostración realizada porque el destino seleccionado fue Chrome y el entorno Android se encuentra configurado.

Limitación 3: conectividad entre dispositivos
Para probar en dispositivos físicos, el backend debe escuchar en 0.0.0.0 y el firewall debe permitir el puerto 3000.

---
## 19. Control de versiones
El proyecto utiliza Git para el control de versiones y GitHub como repositorio remoto.

Repositorio:

text
https://github.com/lams1474/liga_deportiva_app
El repositorio contiene:

Frontend Flutter

Backend Node.js/Express

Estructura de base de datos (Prisma)

Documentación

Configuración del proyecto

---
## 20. Reproducción básica del entorno
Para reproducir el proyecto se recomienda seguir estos pasos:

Paso 1 — Obtener el repositorio
powershell
git clone https://github.com/lams1474/liga_deportiva_app.git
cd liga_deportiva_app
Paso 2 — Preparar el frontend
powershell
cd frontend
flutter pub get
Paso 3 — Verificar Flutter
powershell
flutter doctor -v
Paso 4 — Configurar la base de datos
powershell
cd ../backend
docker-compose up -d
npx prisma migrate dev
npx prisma db seed
Paso 5 — Iniciar el backend
powershell
npm run dev
Paso 6 — Ejecutar Flutter
powershell
cd ../frontend
flutter run -d chrome
Paso 7 — Comprobar el backend
Abrir en el navegador:

text
http://localhost:3000/health
La respuesta debe indicar que el servidor está funcionando correctamente.

Paso 8 — Probar la aplicación
Iniciar sesión con admin@liga.com / 654321

Navegar entre módulos

Probar creación, edición y eliminación

Probar modo avión y sincronización

---
## 21. Estado del proyecto

El proyecto se encuentra **en desarrollo activo**.

### ✅ Completado

- Configuración del entorno multiplataforma
- Autenticación JWT
- CRUD Clubes (con sincronización offline)
- CRUD Jugadores (con sincronización offline)
- Almacenamiento seguro de tokens
- Persistencia local (sqflite)
- Sincronización automática sin conexión
- Cola de operaciones pendientes

### ⏳ En desarrollo

- Disciplinas
- Categorías
- Partidos

### 🔲 Pendiente

- Tabla de posiciones
- Mejoras de UI/UX

---
## 22. Conclusión

La configuración realizada permite disponer de un entorno funcional para el desarrollo de la aplicación móvil multiplataforma de la Liga Deportiva Barrial José Ignacio Izurieta.

Se verificaron las versiones del framework, el diagnóstico del entorno, la ejecución del proyecto Flutter, la recarga en caliente y la comunicación con el backend propio mediante la API REST.

Se implementaron funcionalidades avanzadas como:

- Almacenamiento seguro de tokens con `flutter_secure_storage`
- Persistencia local con `sqflite`
- Sincronización automática con `connectivity_plus`
- Cola de operaciones pendientes con reintentos

La documentación permite identificar las herramientas, versiones, comandos y configuraciones principales utilizadas durante el desarrollo.

---
---

## 23. Interceptores de Dio (Semana 13)

Se implementaron **4 interceptores** en el siguiente orden:

| # | Interceptor | Momento | Responsabilidad |
|---|-------------|---------|-----------------|
| 1 | `AuthInterceptor` | Antes de enviar | Inyecta el token JWT en el header `Authorization` |
| 2 | `RefreshInterceptor` | Ante un 401 | Renueva el token y reintenta la petición |
| 3 | `LogInterceptor` | Antes/después | Registra peticiones (solo en desarrollo) |
| 4 | `ErrorInterceptor` | Ante un error | Traduce errores a mensajes del dominio |

### Flujo de renovación de token

```text
1. Petición → 401 (token expirado)
2. RefreshInterceptor detecta el 401
3. Solicita nuevo token a POST /auth/refresh
4. Guarda el nuevo token
5. Reintenta la petición original
6. Si el refresh falla → cierra sesión


## 📝 Autor

| Campo | Información |
|-------|-------------|
| **Autor** | LAMS1474 |
| **Asignatura** | Aplicaciones Móviles |
| **Proyecto** | Liga Deportiva Barrial José Ignacio Izurieta |
| **Repositorio** | https://github.com/lams1474/liga_deportiva_app |

---

## 📅 Fecha

Septiembre 2026
