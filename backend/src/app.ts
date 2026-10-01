import express from "express";
import cors from "cors";
import morgan from "morgan";
import helmet from "helmet";

import swaggerUi from "swagger-ui-express";
import swaggerSpec from "./config/swagger";

import usuarioRoutes from "./routes/usuario.routes";
console.log("usuario OK");

import clubRoutes from "./routes/club.routes";
console.log("club OK");

import jugadorRoutes from "./routes/jugador.routes";
console.log("jugador OK");

import disciplinaRoutes from "./routes/disciplina.routes";
console.log("disciplina OK");

import categoriaRoutes from "./routes/categoria.routes";
console.log("categoria OK");

import temporadaRoutes from "./routes/temporada.routes";
console.log("temporada OK");

import arbitroRoutes from "./routes/arbitro.routes";
console.log("arbitro OK");

import partidoRoutes from "./routes/partido.routes";
console.log("partido OK");

import resultadoRoutes from "./routes/resultado.routes";
console.log("resultado OK");

import tablaPosicionesRoutes from "./routes/tablaPosiciones.routes";
console.log("tablaPosiciones OK");

import jugadorDisciplinaRoutes from "./routes/jugadorDisciplina.routes";
console.log("jugadorDisciplina OK");

import authRoutes from "./routes/auth.routes";

const app = express();

// 🔥 CORS configurado explícitamente
const corsOptions = {
  origin: true,
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "Accept",
    "Origin",
    "X-Requested-With",
  ],
  exposedHeaders: ["Content-Length", "X-JWT-Token"],
  maxAge: 86400,
};

app.use(cors(corsOptions));

// 🔥 Helmet configurado para permitir CORS
app.use(
  helmet({
    crossOriginResourcePolicy: { policy: "cross-origin" },
    crossOriginOpenerPolicy: { policy: "unsafe-none" },
    contentSecurityPolicy: false,
  }),
);

app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 🔥 Swagger
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Ruta principal
app.get("/", (req, res) => {
  res.send("API Liga Deportiva Barrial José Ignacio Izurieta");
});

// Health Check
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    message: "Servidor funcionando correctamente",
    timestamp: new Date().toISOString(),
  });
});

// Rutas de la API
app.use("/api/usuarios", usuarioRoutes);
app.use("/api/clubes", clubRoutes);
app.use("/api/jugadores", jugadorRoutes);
app.use("/api/disciplinas", disciplinaRoutes);
app.use("/api/categorias", categoriaRoutes);
app.use("/api/temporadas", temporadaRoutes);
app.use("/api/arbitros", arbitroRoutes);
app.use("/api/partidos", partidoRoutes);
app.use("/api/resultados", resultadoRoutes);
app.use("/api/tabla-posiciones", tablaPosicionesRoutes);
app.use("/api/jugador-disciplina", jugadorDisciplinaRoutes);
app.use("/api/auth", authRoutes);

console.log("APP CARGADA");
console.log("Registrando /api/partidos");

export default app;
