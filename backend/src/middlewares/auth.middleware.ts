import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export interface AuthRequest extends Request {
    usuario?: {
        id_usuario: number;
        correo: string;
        rol: string;
    };
}

export const verificarToken = (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {

    try {

        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(401).json({
                mensaje: "Token de autenticación requerido."
            });
        }

        const partes = authHeader.split(" ");

        if (partes.length !== 2 || partes[0] !== "Bearer") {
            return res.status(401).json({
                mensaje: "Formato de token inválido."
            });
        }

        const token = partes[1];

        const secret = process.env.JWT_SECRET;

        if (!secret) {
            return res.status(500).json({
                mensaje: "JWT_SECRET no está configurado."
            });
        }

        const decoded = jwt.verify(token, secret);

        if (typeof decoded === "string") {
            return res.status(401).json({
                mensaje: "Token inválido."
            });
        }

        req.usuario = {
            id_usuario: Number(decoded.id_usuario),
            correo: String(decoded.correo),
            rol: String(decoded.rol)
        };

        next();

    } catch (error) {

        return res.status(401).json({
            mensaje: "Token inválido o expirado."
        });

    }

};