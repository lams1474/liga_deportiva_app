import prisma from "../config/prisma";

export class ClubRepository {

    async obtenerTodos() {
        return await prisma.club.findMany();
    }

    async obtenerPorId(id: number) {
        return await prisma.club.findUnique({
            where: {
                id_club: id
            }
        });
    }

    async obtenerPorNombre(nombre: string) {
        return await prisma.club.findUnique({
            where: {
                nombre
            }
        });
    }

    async crear(data: {
        nombre: string;
        ciudad: string;
        fecha_fundacion?: Date;
    }) {

        return await prisma.club.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            ciudad?: string;
            fecha_fundacion?: Date;
        }
    ) {

        return await prisma.club.update({
            where: {
                id_club: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.club.delete({
            where: {
                id_club: id
            }
        });

    }

}