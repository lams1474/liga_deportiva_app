import prisma from "../config/prisma";

export class JugadorRepository {

    async obtenerTodos() {
        return await prisma.jugador.findMany({
            include: {
                club: true
            }
        });
    }

    async obtenerPorId(id: number) {
        return await prisma.jugador.findUnique({
            where: {
                id_jugador: id
            },
            include: {
                club: true
            }
        });
    }

    async crear(data: {
        nombre: string;
        ciudad: string;
        fecha_nacimiento: Date;
        id_club: number;
    }) {

        return await prisma.jugador.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            ciudad?: string;
            fecha_nacimiento?: Date;
            id_club?: number;
        }
    ) {

        return await prisma.jugador.update({
            where: {
                id_jugador: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.jugador.delete({
            where: {
                id_jugador: id
            }
        });

    }

}