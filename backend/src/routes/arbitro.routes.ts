import { Router } from "express";
import { ArbitroController } from "../controllers/arbitro.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new ArbitroController();

/**
 * @openapi
 * tags:
 *   - name: Árbitros
 *     description: Gestión de árbitros de la liga
 */

/**
 * @openapi
 * /api/arbitros:
 *   get:
 *     summary: Obtener todos los árbitros
 *     tags: [Árbitros]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de árbitros
 *       401:
 *         description: Token no válido o ausente
 */
router.get("/", verificarToken, (req, res) =>
  controller.obtenerTodos(req, res),
);

/**
 * @openapi
 * /api/arbitros/{id}:
 *   get:
 *     summary: Obtener un árbitro por ID
 *     tags: [Árbitros]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del árbitro
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Árbitro encontrado
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Árbitro no encontrado
 */
router.get("/:id", verificarToken, (req, res) =>
  controller.obtenerPorId(req, res),
);

/**
 * @openapi
 * /api/arbitros:
 *   post:
 *     summary: Crear un árbitro
 *     description: Registra un nuevo árbitro. Requiere SUPER_ADMIN.
 *     tags: [Árbitros]
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
 *               - categoria
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Juan Rodríguez
 *               categoria:
 *                 type: string
 *                 example: FIFA
 *     responses:
 *       201:
 *         description: Árbitro creado correctamente
 *       400:
 *         description: Datos incorrectos
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
 * /api/arbitros/{id}:
 *   put:
 *     summary: Actualizar un árbitro
 *     description: Actualiza los datos de un árbitro. Requiere SUPER_ADMIN.
 *     tags: [Árbitros]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del árbitro
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
 *                 example: Juan Rodríguez
 *               categoria:
 *                 type: string
 *                 example: FIFA
 *     responses:
 *       200:
 *         description: Árbitro actualizado correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Árbitro no encontrado
 */
router.put("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.actualizar(req, res),
);

/**
 * @openapi
 * /api/arbitros/{id}:
 *   delete:
 *     summary: Eliminar un árbitro
 *     description: Elimina un árbitro del sistema. Requiere SUPER_ADMIN.
 *     tags: [Árbitros]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del árbitro
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Árbitro eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Árbitro no encontrado
 */
router.delete("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.eliminar(req, res),
);

export default router;
