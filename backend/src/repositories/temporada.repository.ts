import prisma from "../config/prisma";

export class TemporadaRepository {

    async obtenerTodos() {
        return await prisma.temporada.findMany();
    }

    async obtenerPorId(id: number) {
        return await prisma.temporada.findUnique({
            where: {
                id_temporada: id
            }
        });
    }

    async obtenerPorAnio(anio: number) {
        return await prisma.temporada.findUnique({
            where: {
                año: anio
            }
        });
    }

    async crear(data: {
        año: number;
    }) {

        return await prisma.temporada.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            año?: number;
        }
    ) {

        return await prisma.temporada.update({
            where: {
                id_temporada: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.temporada.delete({
            where: {
                id_temporada: id
            }
        });

    }

}