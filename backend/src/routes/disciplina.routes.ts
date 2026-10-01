import { Router } from "express";
import { DisciplinaController } from "../controllers/disciplina.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new DisciplinaController();

/**
 * @openapi
 * tags:
 *   - name: Disciplinas
 *     description: Gestión de disciplinas deportivas
 */

/**
 * @openapi
 * /api/disciplinas:
 *   get:
 *     summary: Obtener todas las disciplinas
 *     tags: [Disciplinas]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de disciplinas
 *       401:
 *         description: Token no válido o ausente
 */
router.get("/", verificarToken, (req, res) =>
  controller.obtenerTodos(req, res),
);

/**
 * @openapi
 * /api/disciplinas/{id}:
 *   get:
 *     summary: Obtener una disciplina por ID
 *     tags: [Disciplinas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la disciplina
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Disciplina encontrada
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Disciplina no encontrada
 */
router.get("/:id", verificarToken, (req, res) =>
  controller.obtenerPorId(req, res),
);

/**
 * @openapi
 * /api/disciplinas:
 *   post:
 *     summary: Crear una disciplina
 *     description: Registra una nueva disciplina. Requiere SUPER_ADMIN.
 *     tags: [Disciplinas]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nombre
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Fútbol
 *     responses:
 *       201:
 *         description: Disciplina creada correctamente
 *       400:
 *         description: Datos incorrectos o disciplina duplicada
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 */
router.post("/", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.crear(req, res),
);

/**
 * @openapi
 * /api/disciplinas/{id}:
 *   put:
 *     summary: Actualizar una disciplina
 *     description: Actualiza los datos de una disciplina. Requiere SUPER_ADMIN.
 *     tags: [Disciplinas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la disciplina
 *         schema:
 *           type: integer
 *           example: 1
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Fútbol
 *     responses:
 *       200:
 *         description: Disciplina actualizada correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Disciplina no encontrada
 */
router.put("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.actualizar(req, res),
);

/**
 * @openapi
 * /api/disciplinas/{id}:
 *   delete:
 *     summary: Eliminar una disciplina
 *     description: Elimina una disciplina del sistema. Requiere SUPER_ADMIN.
 *     tags: [Disciplinas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la disciplina
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Disciplina eliminada correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Disciplina no encontrada
 */
router.delete("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.eliminar(req, res),
);

export default router;
