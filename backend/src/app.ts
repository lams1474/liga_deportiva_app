import express from "express";
import cors from "cors";
import morgan from "morgan";
import helmet from "helmet";


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


const app = express();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Ruta principal
app.get("/", (req, res) => {
  res.send("API Liga Deportiva Barrial José Ignacio Izurieta");
});

// Health Check
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    message: "Servidor funcionando correctamente",
    timestamp: new Date().toISOString()
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

console.log("APP CARGADA");
console.log("Registrando /api/partidos");

export default app;