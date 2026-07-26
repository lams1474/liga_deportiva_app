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

            const resultado = await this.service.login(
                correo,
                contrasena
            );

            res.status(200).json(resultado);

        } catch (error: any) {

            res.status(401).json({
                mensaje: error.message
            });

        }

    }

}