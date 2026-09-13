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
        cedula: string;
        nombre: string;
        ciudad: string;
        fecha_nacimiento: Date;
        id_club: number;
    }) {
        // 🔥 CORREGIDO: Solo enviar los campos necesarios, sin id_jugador ni club
        return await prisma.jugador.create({
            data: {
                cedula: data.cedula,
                nombre: data.nombre,
                ciudad: data.ciudad,
                fecha_nacimiento: data.fecha_nacimiento,
                id_club: data.id_club,
            },
            include: {
                club: true,
            },
        });
    }

    async actualizar(
        id: number,
        data: {
            cedula?: string;
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
            data,
            include: {
                club: true,
            },
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