import prisma from "../config/prisma";

export class TablaPosicionesRepository {

    async obtenerTodos() {

        return await prisma.tablaPosiciones.findMany({
            include: {
                temporada: true,
                club: true
            },
            orderBy: {
                puntos: "desc"
            }
        });

    }

    async obtenerPorId(id: number) {

        return await prisma.tablaPosiciones.findUnique({
            where: {
                id_posicion: id
            },
            include: {
                temporada: true,
                club: true
            }
        });

    }

    async crear(data: {
        id_temporada: number;
        id_club: number;
        puntos: number;
        pj: number;
        pg: number;
        pe: number;
        pp: number;
        gf: number;
        gc: number;
    }) {

        return await prisma.tablaPosiciones.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            puntos?: number;
            pj?: number;
            pg?: number;
            pe?: number;
            pp?: number;
            gf?: number;
            gc?: number;
        }
    ) {

        return await prisma.tablaPosiciones.update({
            where: {
                id_posicion: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.tablaPosiciones.delete({
            where: {
                id_posicion: id
            }
        });

    }

}