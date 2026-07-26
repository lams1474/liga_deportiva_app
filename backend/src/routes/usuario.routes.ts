import { Router } from "express";
import { UsuarioController } from "../controllers/usuario.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { verificarRol } from "../middlewares/rol.middleware";

const router = Router();
const controller = new UsuarioController();

/**
 * @openapi
 * tags:
 *   - name: Usuarios
 *     description: Gestión de usuarios del sistema
 */

/**
 * @openapi
 * /api/usuarios:
 *   get:
 *     summary: Obtener todos los usuarios
 *     description: Consulta todos los usuarios registrados sin exponer sus contraseñas.
 *     tags: [Usuarios]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de usuarios
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
 * /api/usuarios/{id}:
 *   get:
 *     summary: Obtener un usuario por ID
 *     tags: [Usuarios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del usuario
 *         schema:
 *           type: integer
 *           example: 2
 *     responses:
 *       200:
 *         description: Usuario encontrado
 *       401:
 *         description: Token no válido o ausente
 *       404:
 *         description: Usuario no encontrado
 */
router.get(
    "/:id",
    verificarToken,
    (req, res) => controller.obtenerPorId(req, res)
);

/**
 * @openapi
 * /api/usuarios:
 *   post:
 *     summary: Crear un usuario
 *     description: Registra un nuevo usuario en el sistema. Requiere SUPER_ADMIN.
 *     tags: [Usuarios]
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
 *               - correo
 *               - contrasena
 *               - rol
 *             properties:
 *               nombre:
 *                 type: string
 *                 example: Juan Pérez
 *               correo:
 *                 type: string
 *                 format: email
 *                 example: juan@liga.com
 *               contrasena:
 *                 type: string
 *                 format: password
 *                 example: MiPassword123!
 *               rol:
 *                 type: string
 *                 example: ADMIN
 *     responses:
 *       201:
 *         description: Usuario creado correctamente
 *       400:
 *         description: Datos incorrectos o correo ya registrado
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
 * /api/usuarios/{id}:
 *   put:
 *     summary: Actualizar un usuario
 *     description: Actualiza los datos de un usuario. Requiere SUPER_ADMIN.
 *     tags: [Usuarios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del usuario
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
 *                 example: Juan Pérez
 *               correo:
 *                 type: string
 *                 format: email
 *                 example: juan@liga.com
 *               contrasena:
 *                 type: string
 *                 format: password
 *                 example: NuevaPassword123!
 *               rol:
 *                 type: string
 *                 example: ADMIN
 *     responses:
 *       200:
 *         description: Usuario actualizado correctamente
 *       400:
 *         description: Datos incorrectos
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Usuario no encontrado
 */
router.put(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.actualizar(req, res)
);

/**
 * @openapi
 * /api/usuarios/{id}:
 *   delete:
 *     summary: Eliminar un usuario
 *     description: Elimina un usuario del sistema. Requiere SUPER_ADMIN.
 *     tags: [Usuarios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID del usuario
 *         schema:
 *           type: integer
 *           example: 2
 *     responses:
 *       200:
 *         description: Usuario eliminado correctamente
 *       401:
 *         description: Token no válido o ausente
 *       403:
 *         description: El usuario no tiene permisos de SUPER_ADMIN
 *       404:
 *         description: Usuario no encontrado
 */
router.delete(
    "/:id",
    verificarToken,
    verificarRol("SUPER_ADMIN"),
    (req, res) => controller.eliminar(req, res)
);

export default router;