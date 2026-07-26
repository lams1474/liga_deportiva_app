import { Router } from "express";
import { ResultadoController } from "../controllers/resultado.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new ResultadoController;

/**
 * @openapi
 * tags:
 *   - name: Resultados
 *     description: Gestión de resultados de partidos
 */

/**
 * @openapi
 * /api/resultados:
 *   get:
 *     summary: Obtener todos los resultados
 *     tags: [Resultados]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de resultados
 */
router.get(
    "/",
    verificarToken,
    (req, res) => controller.obtenerTodos(req, res)
);

/**
 * @openapi
 * /api/resultados/{id}:
 *   get:
 *     summary: Obtener un resultado por ID
 *     tags: [Resultados]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del resultado
 *     responses:
 *       200:
 *         description: Resultado encontrado
 *       404:
 *         description: Resultado no encontrado
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/resultados:
 *   post:
 *     summary: Registrar un resultado
 *     tags: [Resultados]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_partido
 *               - marcador_local
 *               - marcador_visitante
 *               - registrado_por
 *             properties:
 *               id_partido:
 *                 type: integer
 *                 example: 4
 *               marcador_local:
 *                 type: integer
 *                 example: 2
 *               marcador_visitante:
 *                 type: integer
 *                 example: 1
 *               registrado_por:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       201:
 *         description: Resultado registrado correctamente
 *       400:
 *         description: Error en los datos enviados
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos
 */
router.post(
    "/",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.crear(req, res)
);

/**
 * @openapi
 * /api/resultados/{id}:
 *   put:
 *     summary: Actualizar un resultado
 *     tags: [Resultados]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del resultado
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               marcador_local:
 *                 type: integer
 *                 example: 3
 *               marcador_visitante:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       200:
 *         description: Resultado actualizado correctamente
 *       400:
 *         description: Error en los datos enviados
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/resultados/{id}:
 *   delete:
 *     summary: Eliminar un resultado
 *     tags: [Resultados]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del resultado
 *     responses:
 *       200:
 *         description: Resultado eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;