import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { AuthRepository } from "../repositories/auth.repository";

export class AuthService {

    private repository = new AuthRepository();

    async login(correo: string, contrasena: string) {

        const usuario = await this.repository.obtenerUsuarioPorCorreo(correo);

        if (!usuario) {
            throw new Error("Correo o contraseña incorrectos.");
        }

        const contraseñaValida = await bcrypt.compare(
            contrasena,
            usuario.contrasena
        );

        if (!contraseñaValida) {
            throw new Error("Correo o contraseña incorrectos.");
        }

        const secret = process.env.JWT_SECRET;

        if (!secret) {
            throw new Error("JWT_SECRET no está configurado.");
        }

        const token = jwt.sign(
            {
                id_usuario: usuario.id_usuario,
                correo: usuario.correo,
                rol: usuario.rol
            },
            secret,
            {
                expiresIn: "8h"
            }
        );

        return {
            mensaje: "Inicio de sesión exitoso.",
            token,
            usuario: {
                id_usuario: usuario.id_usuario,
                nombre: usuario.nombre,
                correo: usuario.correo,
                rol: usuario.rol
            }
        };

    }

}