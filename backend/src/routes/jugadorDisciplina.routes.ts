import { Router } from "express";
import { JugadorDisciplinaController } from "../controllers/jugadorDisciplina.controller";

const router = Router();
const controller = new JugadorDisciplinaController();

router.get("/", (req, res) => controller.obtenerTodos(req, res));

router.get(
    "/:id_jugador/:id_disciplina",
    (req, res) => controller.obtenerPorId(req, res)
);

router.post("/", (req, res) => controller.crear(req, res));

router.delete(
    "/:id_jugador/:id_disciplina",
    (req, res) => controller.eliminar(req, res)
);

export default router;