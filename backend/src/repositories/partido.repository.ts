import prisma from "../config/prisma";

export class PartidoRepository {

    async obtenerTodos() {
        return await prisma.partido.findMany({
            include: {
                categoria: true,
                club_local: true,
                club_visitante: true,
                temporada: true,
                arbitro: true,
                programador: {
                    select: {
                        id_usuario: true,
                        nombre: true,
                        correo: true,
                        rol: true
                    }
                },
                resultado: true
            }
        });
    }

    async obtenerPorId(id: number) {
        return await prisma.partido.findUnique({
            where: {
                id_partido: id
            },
            include: {
                categoria: true,
                club_local: true,
                club_visitante: true,
                temporada: true,
                arbitro: true,
                programador: {
                    select: {
                        id_usuario: true,
                        nombre: true,
                        correo: true,
                        rol: true
                    }
                },
                resultado: true
            }
        });
    }

    async crear(data: {
        fecha: Date;
        hora: string;
        lugar: string;
        id_categoria: number;
        id_club_local: number;
        id_club_visitante: number;
        id_temporada: number;
        id_arbitro: number;
        programado_por: number;
    }) {

        return await prisma.partido.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            fecha?: Date;
            hora?: string;
            lugar?: string;
            id_categoria?: number;
            id_club_local?: number;
            id_club_visitante?: number;
            id_temporada?: number;
            id_arbitro?: number;
            programado_por?: number;
        }
    ) {

        return await prisma.partido.update({
            where: {
                id_partido: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.partido.delete({
            where: {
                id_partido: id
            }
        });

    }

}