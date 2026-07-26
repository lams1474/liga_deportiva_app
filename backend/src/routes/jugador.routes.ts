import { Router } from "express";
import { JugadorController } from "../controllers/jugador.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new JugadorController();

/**
 * @openapi
 * tags:
 *   - name: Jugadores
 *     description: Gestión de jugadores de la liga
 */

/**
 * @openapi
 * /api/jugadores:
 *   get:
 *     summary: Obtener todos los jugadores
 *     description: Consulta todos los jugadores registrados.
 *     tags: [Jugadores]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de jugadores
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
 * /api/jugadores/{id}:
 *   get:
 *     summary: Obtener un jugador por ID
 *     tags: [Jugadores]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del jugador
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Jugador encontrado
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Jugador no encontrado
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/jugadores:
 *   post:
 *     summary: Crear un jugador
 *     description: Registra un nuevo jugador. Requiere SUPER_ADMIN.
 *     tags: [Jugadores]
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
 *               - ciudad
 *               - fecha_nacimiento
 *               - id_club
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Luis González
 *               ciudad:
 *                 type: string
 *                 example: Pujili
 *               fecha_nacimiento:
 *                 type: string
 *                 format: date
 *                 example: "2002-08-15"
 *               id_club:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       201:
 *         description: Jugador creado correctamente
 *       400:
 *         description: Datos incorrectos
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
 * /api/jugadores/{id}:
 *   put:
 *     summary: Actualizar un jugador
 *     description: Actualiza los datos de un jugador. Requiere SUPER_ADMIN.
 *     tags: [Jugadores]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del jugador
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
 *                 example: Luis González
 *               ciudad:
 *                 type: string
 *                 example: Pujili
 *               fecha_nacimiento:
 *                 type: string
 *                 format: date
 *                 example: "2002-08-15"
 *               id_club:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       200:
 *         description: Jugador actualizado correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Jugador no encontrado
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/jugadores/{id}:
 *   delete:
 *     summary: Eliminar un jugador
 *     description: Elimina un jugador del sistema. Requiere SUPER_ADMIN.
 *     tags: [Jugadores]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del jugador
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Jugador eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Jugador no encontrado
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;