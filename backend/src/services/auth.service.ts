import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import prisma from '../config/prisma';

export class AuthService {

    async login(correo: string, contrasena: string) {
        // Buscar usuario
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario) {
            throw new Error('Correo o contraseña incorrectos.');
        }

        // Verificar contraseña
        const contrasenaValida = await bcrypt.compare(contrasena, usuario.contrasena);

        if (!contrasenaValida) {
            throw new Error('Correo o contraseña incorrectos.');
        }

        // Generar tokens
        const secret = process.env.JWT_SECRET || 'default_secret';

        const token = jwt.sign(
            {
                id_usuario: usuario.id_usuario,
                correo: usuario.correo,
                rol: usuario.rol,
            },
            secret,
            { expiresIn: '1m' }
        );

        // 🔥 Refresh token: vida más larga
        const refreshToken = jwt.sign(
            {
                id_usuario: usuario.id_usuario,
                tipo: 'refresh',
            },
            secret,
            { expiresIn: '7d' }
        );

        return {
            mensaje: 'Inicio de sesión exitoso.',
            token,
            refreshToken,  // 🔥 NUEVO
            usuario: {
                id_usuario: usuario.id_usuario,
                nombre: usuario.nombre,
                correo: usuario.correo,
                rol: usuario.rol,
            },
        };
    }

    // 🔥 NUEVO: Renovar access token
    async refresh(refreshToken: string) {
        if (!refreshToken) {
            throw new Error('Refresh token requerido.');
        }

        const secret = process.env.JWT_SECRET || 'default_secret';

        try {
            // Verificar el refresh token
            const decoded = jwt.verify(refreshToken, secret);

            if (typeof decoded === 'string' || decoded.tipo !== 'refresh') {
                throw new Error('Refresh token inválido.');
            }

            // Buscar usuario
            const usuario = await prisma.usuario.findUnique({
                where: { id_usuario: decoded.id_usuario },
            });

            if (!usuario) {
                throw new Error('Usuario no encontrado.');
            }

            // Generar nuevo access token
            const nuevoToken = jwt.sign(
                {
                    id_usuario: usuario.id_usuario,
                    correo: usuario.correo,
                    rol: usuario.rol,
                },
                secret,
                { expiresIn: '8h' }
            );

            return {
                mensaje: 'Token renovado exitosamente.',
                token: nuevoToken,
            };
        } catch (error) {
            throw new Error('Refresh token inválido o expirado.');
        }
    }
}