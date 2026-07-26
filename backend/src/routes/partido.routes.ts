import { Router } from "express";
import { PartidoController } from "../controllers/partido.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new PartidoController();

/**
 * @openapi
 * tags:
 *   - name: Partidos
 *     description: Gestión y programación de partidos
 */

/**
 * @openapi
 * /api/partidos:
 *   get:
 *     summary: Obtener todos los partidos
 *     description: Consulta todos los partidos registrados con sus relaciones.
 *     tags: [Partidos]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de partidos
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
 * /api/partidos/{id}:
 *   get:
 *     summary: Obtener un partido por ID
 *     tags: [Partidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del partido
 *         schema:
 *           type: integer
 *           example: 4
 *     responses:
 *       200:
 *         description: Partido encontrado
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Partido no encontrado
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/partidos:
 *   post:
 *     summary: Registrar un nuevo partido
 *     description: Crea un partido. Requiere permisos de SUPER_ADMIN.
 *     tags: [Partidos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - fecha
 *               - hora
 *               - lugar
 *               - id_categoria
 *               - id_club_local
 *               - id_club_visitante
 *               - id_temporada
 *               - id_arbitro
 *               - programado_por
 *             properties:
 *               fecha:
 *                 type: string
 *                 format: date
 *                 example: "2026-08-11"
 *               hora:
 *                 type: string
 *                 example: "15:30"
 *               lugar:
 *                 type: string
 *                 example: "Estadio Central Pujilí"
 *               id_categoria:
 *                 type: integer
 *                 example: 1
 *               id_club_local:
 *                 type: integer
 *                 example: 2
 *               id_club_visitante:
 *                 type: integer
 *                 example: 3
 *               id_temporada:
 *                 type: integer
 *                 example: 2
 *               id_arbitro:
 *                 type: integer
 *                 example: 2
 *               programado_por:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       201:
 *         description: Partido creado correctamente
 *       400:
 *         description: Datos incorrectos o clubes iguales
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
 * /api/partidos/{id}:
 *   put:
 *     summary: Actualizar un partido
 *     description: Actualiza los datos de un partido. Requiere SUPER_ADMIN.
 *     tags: [Partidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del partido
 *         schema:
 *           type: integer
 *           example: 4
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               fecha:
 *                 type: string
 *                 format: date
 *                 example: "2026-08-11"
 *               hora:
 *                 type: string
 *                 example: "15:30"
 *               lugar:
 *                 type: string
 *                 example: "Estadio Central Pujilí"
 *               id_categoria:
 *                 type: integer
 *                 example: 1
 *               id_club_local:
 *                 type: integer
 *                 example: 2
 *               id_club_visitante:
 *                 type: integer
 *                 example: 3
 *               id_temporada:
 *                 type: integer
 *                 example: 2
 *               id_arbitro:
 *                 type: integer
 *                 example: 2
 *               programado_por:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       200:
 *         description: Partido actualizado correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Partido no encontrado
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/partidos/{id}:
 *   delete:
 *     summary: Eliminar un partido
 *     description: Elimina un partido. Requiere SUPER_ADMIN.
 *     tags: [Partidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del partido
 *         schema:
 *           type: integer
 *           example: 4
 *     responses:
 *       200:
 *         description: Partido eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Partido no encontrado
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;