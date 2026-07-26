import { Response, NextFunction } from "express";
import { AuthRequest } from "./auth.middleware";

export const verificarRol = (...rolesPermitidos: string[]) => {

    return (
        req: AuthRequest,
        res: Response,
        next: NextFunction
    ) => {

        if (!req.usuario) {
            return res.status(401).json({
                mensaje: "Usuario no autenticado."
            });
        }

        if (!rolesPermitidos.includes(req.usuario.rol)) {
            return res.status(403).json({
                mensaje: "No tiene permisos para realizar esta acción."
            });
        }

        next();
    };

};