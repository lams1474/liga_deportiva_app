import prisma from "../config/prisma";

export class DisciplinaRepository {

    async obtenerTodos() {
        return await prisma.disciplina.findMany();
    }

    async obtenerPorId(id: number) {
        return await prisma.disciplina.findUnique({
            where: {
                id_disciplina: id
            }
        });
    }

    async obtenerPorNombre(nombre: string) {
        return await prisma.disciplina.findUnique({
            where: {
                nombre
            }
        });
    }

    async crear(data: {
        nombre: string;
    }) {

        return await prisma.disciplina.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
        }
    ) {

        return await prisma.disciplina.update({
            where: {
                id_disciplina: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.disciplina.delete({
            where: {
                id_disciplina: id
            }
        });

    }

}