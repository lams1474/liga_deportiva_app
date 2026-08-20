# Liga Deportiva Barrial José Ignacio Izurieta

Proyecto integrador de la asignatura **Aplicaciones Móviles**.

La aplicación tiene como objetivo apoyar la gestión de la Liga Deportiva Barrial José Ignacio Izurieta mediante una arquitectura cliente-servidor. El frontend móvil multiplataforma está desarrollado con Flutter y consume los servicios REST proporcionados por el backend.

## 1. Tecnologías utilizadas

### Frontend

* Flutter 3.44.6
* Dart 3.12.2
* DevTools 2.57.0
* Provider
* Dio
* Flutter Secure Storage

### Backend

* Node.js
* TypeScript
* Express
* Prisma ORM
* API REST

### Base de datos

* MySQL 8
* Docker

### Herramientas de desarrollo

* Visual Studio Code
* Android Studio
* Google Chrome
* Git
* GitHub

---

## 2. Arquitectura

El proyecto utiliza una arquitectura **cliente-servidor**.

```text
┌─────────────────────────────┐
│       Aplicación Flutter    │
│          Frontend           │
└──────────────┬──────────────┘
               │
               │ HTTP / REST
               ▼
┌─────────────────────────────┐
│       API REST Backend      │
│     Node.js / Express       │
└──────────────┬──────────────┘
               │
               │ Prisma ORM
               ▼
┌─────────────────────────────┐
│          MySQL 8            │
│           Docker            │
└─────────────────────────────┘
```

La aplicación Flutter realiza solicitudes HTTP hacia la API del backend para autenticación y gestión de información.

---

## 3. Framework seleccionado

Se seleccionó **Flutter** como framework multiplataforma porque permite desarrollar aplicaciones para diferentes plataformas utilizando una única base de código.

Para este proyecto, Flutter permite trabajar con Dart y facilita el desarrollo de la interfaz, la integración con servicios HTTP y la ejecución durante las etapas de desarrollo mediante recarga en caliente.

---

## 4. Características del entorno

El entorno utilizado para el desarrollo corresponde a:

* Sistema operativo: Windows 11 Pro 64 bits
* Versión de Windows: 23H2
* Procesador: AMD Ryzen 3 3250U
* Memoria RAM: 4 GB
* Flutter: 3.44.6
* Dart: 3.12.2
* DevTools: 2.57.0
* Android SDK: 36.1.0
* Build Tools: 36.1.0
* Java: OpenJDK 21.0.10
* Navegador utilizado como destino: Google Chrome

---

## 5. Verificación de Flutter

Para comprobar la versión instalada se utiliza:

```powershell
flutter --version
```

Para realizar el diagnóstico completo del entorno:

```powershell
flutter doctor -v
```

Para verificar los destinos disponibles:

```powershell
flutter devices
```

El diagnóstico permitió comprobar que Flutter, Windows, Android Toolchain, Chrome y los recursos de red se encuentran disponibles.

Durante el diagnóstico se identificó que Visual Studio no está instalado para el desarrollo de aplicaciones Windows. Esta herramienta no fue necesaria para la demostración realizada, debido a que el destino seleccionado fue Chrome.

---

## 6. Estructura principal del proyecto

```text
liga_deportiva_app/
│
├── backend/
│   └── src/
│
├── database/
│
├── docs/
│
├── frontend/
│   ├── lib/
│   │   ├── config/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── services/
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
├── .gitignore
└── README.md
```

---

## 7. Ejecución del frontend

Para ejecutar el proyecto Flutter:

```powershell
cd frontend
flutter run -d chrome
```

También se puede utilizar:

```powershell
flutter devices
```

para consultar los destinos disponibles.

Durante la demostración se utilizó **Google Chrome** como destino de ejecución.

La elección de Chrome permitió ejecutar y verificar la aplicación utilizando los recursos disponibles del equipo, evitando la carga adicional de un emulador Android.

---

## 8. Recarga en caliente

Flutter permite utilizar **Hot Reload** durante el desarrollo.

La recarga en caliente permite observar cambios realizados en el código sin tener que reiniciar completamente la aplicación, facilitando el desarrollo y las pruebas de la interfaz.

---

## 9. Backend

El backend se ejecuta mediante Node.js.

Para iniciar el servidor:

```powershell
cd backend
npm run dev
```

El servidor queda disponible en:

```text
http://localhost:3000
```

El backend proporciona además un endpoint de comprobación:

```text
http://localhost:3000/health
```

Una respuesta correcta del endpoint es:

```json
{
  "status": "OK",
  "message": "Servidor funcionando correctamente",
  "timestamp": "..."
}
```

---

## 10. Configuración de la API

La URL base utilizada por el frontend se encuentra definida en:

```text
frontend/lib/config/api_config.dart
```

Configuración utilizada durante el desarrollo:

```dart
class ApiConfig {
  static const String baseUrl = "http://localhost:3000/api";
}
```

La dirección `localhost` corresponde al equipo local donde se encuentra ejecutándose el backend.

Esta configuración corresponde al entorno de desarrollo local y debe modificarse cuando la aplicación se despliegue en un entorno diferente.

---

## 11. Autenticación y comunicación con la API

La aplicación utiliza autenticación para acceder a los recursos protegidos del backend.

El frontend almacena el token de autenticación mediante almacenamiento seguro y lo envía en las solicitudes protegidas mediante el encabezado:

```text
Authorization: Bearer <token>
```

Durante la verificación del entorno se comprobó la autenticación mediante una solicitud:

```text
POST /api/auth/login
```

con respuesta exitosa:

```text
200
```

Posteriormente se verificó el acceso al recurso de clubes mediante:

```text
GET /api/clubes
```

obteniendo una respuesta exitosa:

```text
200
```

Esto permitió comprobar que la aplicación Flutter puede comunicarse correctamente con el backend propio del proyecto.

---

## 12. Dependencias principales del frontend

Entre las dependencias utilizadas se encuentran:

* `dio`: cliente HTTP utilizado para realizar solicitudes hacia la API.
* `provider`: administración del estado de la aplicación.
* `flutter_secure_storage`: almacenamiento seguro del token de autenticación.

Estas dependencias se encuentran registradas en:

```text
frontend/pubspec.yaml
```

---

## 13. Base de datos

La aplicación utiliza MySQL 8 como sistema de gestión de base de datos.

La base de datos se ejecuta mediante Docker durante el desarrollo.

El backend utiliza Prisma ORM para interactuar con la base de datos.

La arquitectura utilizada es:

```text
Flutter
   ↓
API REST
   ↓
Prisma ORM
   ↓
MySQL
   ↓
Docker
```

---

## 14. Verificación de conectividad

La conectividad fue comprobada en dos niveles.

### Health Check

```text
GET /health
```

Resultado:

```text
200 OK
```

### API protegida

```text
POST /api/auth/login
```

Resultado:

```text
200 OK
```

Posteriormente:

```text
GET /api/clubes
```

Resultado:

```text
200 OK
```

La evidencia confirma que el frontend puede autenticarse y consumir un endpoint del backend propio.

---

## 15. Limitaciones del entorno

### Limitación 1: memoria disponible

El equipo dispone de 4 GB de memoria RAM. La ejecución simultánea de Flutter, el backend, Docker y herramientas adicionales puede generar un consumo considerable de recursos.

Como estrategia de mitigación se utilizó **Google Chrome como destino de ejecución**, evitando depender de un emulador Android durante la demostración.

### Limitación 2: desarrollo para Windows

El diagnóstico `flutter doctor -v` reportó que Visual Studio no está instalado para el desarrollo de aplicaciones Windows.

Esta limitación no afecta la demostración realizada porque el destino seleccionado fue Chrome y el entorno Android se encuentra configurado.

---

## 16. Control de versiones

El proyecto utiliza Git para el control de versiones y GitHub como repositorio remoto.

Repositorio:

https://github.com/lams1474/liga_deportiva_app

El repositorio contiene:

* frontend Flutter;
* backend;
* estructura de base de datos;
* documentación;
* configuración del proyecto.

---

## 17. Reproducción básica del entorno

Para reproducir el proyecto se recomienda seguir estos pasos:

### Paso 1 — Obtener el repositorio

```powershell
git clone https://github.com/lams1474/liga_deportiva_app.git
cd liga_deportiva_app
```

### Paso 2 — Preparar el frontend

```powershell
cd frontend
flutter pub get
```

### Paso 3 — Verificar Flutter

```powershell
flutter doctor -v
```

### Paso 4 — Iniciar el backend

En otra terminal:

```powershell
cd backend
npm install
npm run dev
```

### Paso 5 — Ejecutar Flutter

Desde la carpeta `frontend`:

```powershell
flutter run -d chrome
```

### Paso 6 — Comprobar el backend

Abrir:

```text
http://localhost:3000/health
```

La respuesta debe indicar que el servidor está funcionando correctamente.

---

## 18. Estado del proyecto

El proyecto se encuentra **en desarrollo**.

Durante esta etapa se ha configurado el entorno multiplataforma, se ha implementado la comunicación entre frontend y backend y se han realizado pruebas de autenticación y operaciones sobre la información de clubes.

Las siguientes etapas continuarán con la construcción y ampliación de la interfaz y funcionalidades de la aplicación.

---

## 19. Conclusión

La configuración realizada permite disponer de un entorno funcional para el desarrollo de la aplicación móvil multiplataforma de la Liga Deportiva Barrial José Ignacio Izurieta.

Se verificaron las versiones del framework, el diagnóstico del entorno, la ejecución del proyecto Flutter, la recarga en caliente y la comunicación con el backend propio mediante la API REST.

La documentación permite identificar las herramientas, versiones, comandos y configuraciones principales utilizadas durante el desarrollo.
