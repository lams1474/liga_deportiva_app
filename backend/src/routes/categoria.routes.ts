import { Router } from "express";
import { CategoriaController } from "../controllers/categoria.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new CategoriaController();

/**
 * @openapi
 * tags:
 *   - name: Categorías
 *     description: Gestión de categorías por disciplina
 */

/**
 * @openapi
 * /api/categorias:
 *   get:
 *     summary: Obtener todas las categorías
 *     description: Devuelve las categorías con su disciplina asociada.
 *     tags: [Categorías]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de categorías
 *       401:
 *         description: Token no válido o ausente
 */
router.get("/", verificarToken, (req, res) =>
  controller.obtenerTodos(req, res),
);

/**
 * @openapi
 * /api/categorias/{id}:
 *   get:
 *     summary: Obtener una categoría por ID
 *     tags: [Categorías]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la categoría
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Categoría encontrada
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Categoría no encontrada
 */
router.get("/:id", verificarToken, (req, res) =>
  controller.obtenerPorId(req, res),
);

/**
 * @openapi
 * /api/categorias:
 *   post:
 *     summary: Crear una categoría
 *     description: Registra una nueva categoría asociada a una disciplina. Requiere SUPER_ADMIN.
 *     tags: [Categorías]
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
 *               - id_disciplina
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Sub-15
 *               id_disciplina:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: Categoría creada correctamente
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
 * /api/categorias/{id}:
 *   put:
 *     summary: Actualizar una categoría
 *     description: Actualiza los datos de una categoría. Requiere SUPER_ADMIN.
 *     tags: [Categorías]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la categoría
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
 *                 example: Sub-15
 *               id_disciplina:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       200:
 *         description: Categoría actualizada correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Categoría no encontrada
 */
router.put("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.actualizar(req, res),
);

/**
 * @openapi
 * /api/categorias/{id}:
 *   delete:
 *     summary: Eliminar una categoría
 *     description: Elimina una categoría del sistema. Requiere SUPER_ADMIN.
 *     tags: [Categorías]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID de la categoría
 *         schema:
 *           type: integer
 *           example: 1
 *     responses:
 *       200:
 *         description: Categoría eliminada correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Categoría no encontrada
 */
router.delete("/:id", verificarToken, verificarRol("SUPER_ADMIN"), (req, res) =>
  controller.eliminar(req, res),
);

export default router;
