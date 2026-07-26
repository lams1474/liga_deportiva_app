import { Router } from "express";
import { ClubController } from "../controllers/club.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new ClubController();

/**
 * @openapi
 * tags:
 *   - name: Clubes
 *     description: Gestión de clubes deportivos
 */

/**
 * @openapi
 * /api/clubes:
 *   get:
 *     summary: Obtener todos los clubes
 *     tags: [Clubes]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de clubes
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
 * /api/clubes/{id}:
 *   get:
 *     summary: Obtener un club por ID
 *     tags: [Clubes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del club
 *         schema:
 *           type: integer
 *           example: 2
 *     responses:
 *       200:
 *         description: Club encontrado
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Club no encontrado
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/clubes:
 *   post:
 *     summary: Crear un club
 *     description: Registra un nuevo club deportivo. Requiere SUPER_ADMIN.
 *     tags: [Clubes]
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
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Club Deportivo Spartanos FC
 *               ciudad:
 *                 type: string
 *                 example: Pujili
 *               fecha_fundacion:
 *                 type: string
 *                 format: date
 *                 nullable: true
 *                 example: "2012-05-15"
 *     responses:
 *       201:
 *         description: Club creado correctamente
 *       400:
 *         description: Datos incorrectos o club duplicado
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
 * /api/clubes/{id}:
 *   put:
 *     summary: Actualizar un club
 *     description: Actualiza los datos de un club. Requiere SUPER_ADMIN.
 *     tags: [Clubes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del club
 *         schema:
 *           type: integer
 *           example: 2
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Club Deportivo Spartanos FC
 *               ciudad:
 *                 type: string
 *                 example: Pujili
 *               fecha_fundacion:
 *                 type: string
 *                 format: date
 *                 nullable: true
 *                 example: "2012-05-15"
 *     responses:
 *       200:
 *         description: Club actualizado correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Club no encontrado
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/clubes/{id}:
 *   delete:
 *     summary: Eliminar un club
 *     description: Elimina un club del sistema. Requiere SUPER_ADMIN.
 *     tags: [Clubes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del club
 *         schema:
 *           type: integer
 *           example: 2
 *     responses:
 *       200:
 *         description: Club eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Club no encontrado
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;