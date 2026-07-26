import { Router } from "express";
import { JugadorDisciplinaController } from "../controllers/jugadorDisciplina.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new JugadorDisciplinaController();

/**
 * @openapi
 * tags:
 *   - name: JugadorDisciplina
 *     description: Gestión de disciplinas asignadas a jugadores
 */

/**
 * @openapi
 * /api/jugador-disciplina:
 *   get:
 *     summary: Obtener todas las relaciones jugador-disciplina
 *     description: Consulta todas las disciplinas asignadas a los jugadores.
 *     tags: [JugadorDisciplina]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de relaciones jugador-disciplina
 *       401:
 *         description: Token no válido o ausente
 */
router.get(
    "/",
    verificarToken,
    (req, res) => controller.obtenerTodos(req, res)
);

/**
 * @openapi
 * /api/jugador-disciplina/{id_jugador}/{id_disciplina}:
 *   get:
 *     summary: Obtener una relación jugador-disciplina
 *     tags: [JugadorDisciplina]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id_jugador
 *         required: true
 *         description: ID del jugador
 *         schema:
 *           type: integer
 *           example: 1
 *       - in: path
 *         name: id_disciplina
 *         required: true
 *         description: ID de la disciplina
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Relación encontrada
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Relación no encontrada
 */
router.get(
    "/:id_jugador/:id_disciplina",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/jugador-disciplina:
 *   post:
 *     summary: Asignar una disciplina a un jugador
 *     description: Registra la relación entre un jugador y una disciplina. Requiere SUPER_ADMIN.
 *     tags: [JugadorDisciplina]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_jugador
 *               - id_disciplina
 *             properties:
 *               id_jugador:
 *                 type: integer
 *                 example: 1
 *               id_disciplina:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: Disciplina asignada correctamente
 *       400:
 *         description: La relación ya existe o los datos son incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 */
router.post(
    "/",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.crear(req, res)
);

/**
 * @openapi
 * /api/jugador-disciplina/{id_jugador}/{id_disciplina}:
 *   delete:
 *     summary: Eliminar una disciplina de un jugador
 *     description: Elimina la relación entre un jugador y una disciplina. Requiere SUPER_ADMIN.
 *     tags: [JugadorDisciplina]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id_jugador
 *         required: true
 *         description: ID del jugador
 *         schema:
 *           type: integer
 *           example: 1
 *       - in: path
 *         name: id_disciplina
 *         required: true
 *         description: ID de la disciplina
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Relación eliminada correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Relación no encontrada
 */
router.delete(
    "/:id_jugador/:id_disciplina",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;