import { Router } from "express";
import { TablaPosicionesController } from "../controllers/tablaPosiciones.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new TablaPosicionesController();

/**
 * @openapi
 * tags:
 *   - name: Tabla de Posiciones
 *     description: Gestión de la tabla de posiciones por temporada
 */

/**
 * @openapi
 * /api/tabla-posiciones:
 *   get:
 *     summary: Obtener la tabla de posiciones
 *     description: Consulta todas las posiciones registradas.
 *     tags: [Tabla de Posiciones]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de posiciones
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
 * /api/tabla-posiciones/{id}:
 *   get:
 *     summary: Obtener una posición por ID
 *     tags: [Tabla de Posiciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la posición
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Posición encontrada
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Posición no encontrada
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/tabla-posiciones:
 *   post:
 *     summary: Crear una posición
 *     description: Registra la posición de un club dentro de una temporada. Requiere SUPER_ADMIN.
 *     tags: [Tabla de Posiciones]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_temporada
 *               - id_club
 *             properties:
 *               id_temporada:
 *                 type: integer
 *                 example: 2
 *               id_club:
 *                 type: integer
 *                 example: 2
 *               puntos:
 *                 type: integer
 *                 example: 3
 *               pj:
 *                 type: integer
 *                 example: 1
 *               pg:
 *                 type: integer
 *                 example: 1
 *               pe:
 *                 type: integer
 *                 example: 0
 *               pp:
 *                 type: integer
 *                 example: 0
 *               gf:
 *                 type: integer
 *                 example: 2
 *               gc:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: Posición creada correctamente
 *       400:
 *         description: Datos incorrectos o posición duplicada
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
 * /api/tabla-posiciones/{id}:
 *   put:
 *     summary: Actualizar una posición
 *     description: Actualiza los datos de una posición. Requiere SUPER_ADMIN.
 *     tags: [Tabla de Posiciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la posición
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
 *               puntos:
 *                 type: integer
 *                 example: 6
 *               pj:
 *                 type: integer
 *                 example: 2
 *               pg:
 *                 type: integer
 *                 example: 2
 *               pe:
 *                 type: integer
 *                 example: 0
 *               pp:
 *                 type: integer
 *                 example: 0
 *               gf:
 *                 type: integer
 *                 example: 5
 *               gc:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       200:
 *         description: Posición actualizada correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Posición no encontrada
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/tabla-posiciones/{id}:
 *   delete:
 *     summary: Eliminar una posición
 *     description: Elimina una posición de la tabla. Requiere SUPER_ADMIN.
 *     tags: [Tabla de Posiciones]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la posición
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Posición eliminada correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Posición no encontrada
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;