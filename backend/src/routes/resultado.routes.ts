import { Router } from "express";
import { ResultadoController } from "../controllers/resultado.controller";

const router = Router();
const controller = new ResultadoController();

router.get("/", (req, res) => controller.obtenerTodos(req, res));

router.get("/:id", (req, res) => controller.obtenerPorId(req, res));

router.post("/", (req, res) => controller.crear(req, res));

router.put("/:id", (req, res) => controller.actualizar(req, res));

router.delete("/:id", (req, res) => controller.eliminar(req, res));

export default router;