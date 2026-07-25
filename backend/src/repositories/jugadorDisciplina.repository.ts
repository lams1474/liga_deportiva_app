import prisma from "../config/prisma";

export class JugadorDisciplinaRepository {

    async obtenerTodos() {

        return await prisma.jugadorDisciplina.findMany({
            include: {
                jugador: true,
                disciplina: true
            }
        });

    }

    async obtenerPorId(id_jugador: number, id_disciplina: number) {

        return await prisma.jugadorDisciplina.findUnique({
            where: {
                id_jugador_id_disciplina: {
                    id_jugador,
                    id_disciplina
                }
            },
            include: {
                jugador: true,
                disciplina: true
            }
        });

    }

    async crear(data: {
        id_jugador: number;
        id_disciplina: number;
    }) {

        return await prisma.jugadorDisciplina.create({
            data
        });

    }

    async eliminar(id_jugador: number, id_disciplina: number) {

        return await prisma.jugadorDisciplina.delete({
            where: {
                id_jugador_id_disciplina: {
                    id_jugador,
                    id_disciplina
                }
            }
        });

    }

}