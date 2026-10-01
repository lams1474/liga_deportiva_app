import { Router } from "express";
import { TemporadaController } from "../controllers/temporada.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new TemporadaController();

/**
 * @openapi
 * tags:
 *   - name: Temporadas
 *     description: Gestión de temporadas deportivas
 */

/**
 * @openapi
 * /api/temporadas:
 *   get:
 *     summary: Obtener todas las temporadas
 *     tags: [Temporadas]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de temporadas
 *       401:
 *         description: Token no válido o ausente
 */
router.get("/", verificarToken, (req, res) =>
  controller.obtenerTodos(req, res),
);

/**
 * @openapi
 * /api/temporadas/{id}:
 *   get:
 *     summary: Obtener una temporada por ID
 *     tags: [Temporadas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la temporada
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Temporada encontrada
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Temporada no encontrada
 */
router.get("/:id", verificarToken, (req, res) =>
  controller.obtenerPorId(req, res),
);

/**
 * @openapi
 * /api/temporadas:
 *   post:
 *     summary: Crear una temporada
 *     description: Registra una nueva temporada. Requiere SUPER_ADMIN.
 *     tags: [Temporadas]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - año
 *             properties:
 *               año:
 *                 type: integer
 *                 example: 2026
 *     responses:
 *       201:
 *         description: Temporada creada correctamente
 *       400:
 *         description: Datos incorrectos o temporada duplicada
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
 * /api/temporadas/{id}:
 *   put:
 *     summary: Actualizar una temporada
 *     description: Actualiza los datos de una temporada. Requiere SUPER_ADMIN.
 *     tags: [Temporadas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la temporada
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
 *               año:
 *                 type: integer
 *                 example: 2026
 *     responses:
 *       200:
 *         description: Temporada actualizada correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Temporada no encontrada
 */
router.put("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.actualizar(req, res),
);

/**
 * @openapi
 * /api/temporadas/{id}:
 *   delete:
 *     summary: Eliminar una temporada
 *     description: Elimina una temporada del sistema. Requiere SUPER_ADMIN.
 *     tags: [Temporadas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la temporada
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Temporada eliminada correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Temporada no encontrada
 */
router.delete("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.eliminar(req, res),
);

export default router;
