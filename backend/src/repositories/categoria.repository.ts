import prisma from "../config/prisma";

export class CategoriaRepository {

    async obtenerTodos() {
        return await prisma.categoria.findMany({
            include: {
                disciplina: true
            }
        });
    }

    async obtenerPorId(id: number) {
        return await prisma.categoria.findUnique({
            where: {
                id_categoria: id
            },
            include: {
                disciplina: true
            }
        });
    }

    async crear(data: {
        nombre: string;
        id_disciplina: number;
    }) {

        return await prisma.categoria.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            id_disciplina?: number;
        }
    ) {

        return await prisma.categoria.update({
            where: {
                id_categoria: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.categoria.delete({
            where: {
                id_categoria: id
            }
        });

    }

}