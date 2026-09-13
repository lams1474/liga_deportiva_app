import { Router } from "express";
import { AuthController } from "../controllers/auth.controller";

const router = Router();
const controller = new AuthController();

/**
 * @openapi
 * tags:
 *   - name: Autenticación
 *     description: Inicio de sesión y autenticación de usuarios
 */

/**
 * @openapi
 * /api/auth/login:
 *   post:
 *     summary: Iniciar sesión
 *     description: Autentica un usuario y genera un token JWT.
 *     tags: [Autenticación]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - correo
 *               - contrasena
 *             properties:
 *               correo:
 *                 type: string
 *                 format: email
 *                 example: admin@liga.com
 *               contrasena:
 *                 type: string
 *                 format: password
 *                 example: 123456
 *     responses:
 *       200:
 *         description: Inicio de sesión exitoso
 *       400:
 *         description: Datos de acceso incorrectos
 *       401:
 *         description: Credenciales inválidas
 */
router.post(
    "/login",
    (req, res) => controller.login(req, res)
);

/**
 * @openapi
 * /api/auth/refresh:
 *   post:
 *     summary: Renovar token de acceso
 *     description: Genera un nuevo token de acceso usando un refresh token válido.
 *     tags: [Autenticación]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - refreshToken
 *             properties:
 *               refreshToken:
 *                 type: string
 *                 example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
 *     responses:
 *       200:
 *         description: Token renovado exitosamente
 *       400:
 *         description: Refresh token requerido
 *       401:
 *         description: Refresh token inválido o expirado
 */
router.post(
    "/refresh",
    (req, res) => controller.refresh(req, res)
);

export default router;