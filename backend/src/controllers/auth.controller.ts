import { Request, Response } from "express";
import { AuthService } from "../services/auth.service";

export class AuthController {

    private service = new AuthService();

    async login(req: Request, res: Response) {
        try {
            const { correo, contrasena } = req.body;

            if (!correo || !contrasena) {
                return res.status(400).json({
                    mensaje: "El correo y la contraseña son obligatorios."
                });
            }

            const resultado = await this.service.login(correo, contrasena);
            res.status(200).json(resultado);
        } catch (error: any) {
            res.status(401).json({
                mensaje: error.message
            });
        }
    }

    // 🔥 NUEVO: Renovar token
    async refresh(req: Request, res: Response) {
        try {
            const { refreshToken } = req.body;

            if (!refreshToken) {
                return res.status(400).json({
                    mensaje: "Refresh token requerido."
                });
            }

            const resultado = await this.service.refresh(refreshToken);
            res.status(200).json(resultado);
        } catch (error: any) {
            res.status(401).json({
                mensaje: error.message
            });
        }
    }
}