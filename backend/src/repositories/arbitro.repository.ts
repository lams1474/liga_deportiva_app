import prisma from "../config/prisma";

export class ArbitroRepository {

    async obtenerTodos() {
        return await prisma.arbitro.findMany();
    }

    async obtenerPorId(id: number) {
        return await prisma.arbitro.findUnique({
            where: {
                id_arbitro: id
            }
        });
    }

    async crear(data: {
        nombre: string;
        categoria: string;
    }) {

        return await prisma.arbitro.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            categoria?: string;
        }
    ) {

        return await prisma.arbitro.update({
            where: {
                id_arbitro: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.arbitro.delete({
            where: {
                id_arbitro: id
            }
        });

    }

}