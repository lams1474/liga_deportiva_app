import prisma from "../config/prisma";

export class UsuarioRepository {

    async obtenerTodos() {
        return await prisma.usuario.findMany();
    }

    async obtenerPorId(id: number) {
        return await prisma.usuario.findUnique({
            where: {
                id_usuario: id
            }
        });
    }

    async obtenerPorCorreo(correo: string) {
        return await prisma.usuario.findUnique({
            where: {
                correo
            }
        });
    }

    async crear(data: {
        nombre: string;
        correo: string;
        contrasena: string;
        rol: string;
    }) {

        return await prisma.usuario.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            correo?: string;
            contrasena?: string;
            rol?: string;
        }
    ) {

        return await prisma.usuario.update({
            where: {
                id_usuario: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.usuario.delete({
            where: {
                id_usuario: id
            }
        });

    }

}