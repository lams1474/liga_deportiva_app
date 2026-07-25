import prisma from "../config/prisma";

export class AuthRepository {

    async obtenerUsuarioPorCorreo(correo: string) {

        return await prisma.usuario.findUnique({
            where: {
                correo
            }
        });

    }

}