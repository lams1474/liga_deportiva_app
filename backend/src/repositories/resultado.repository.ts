import prisma from "../config/prisma";

export class ResultadoRepository {

    async obtenerTodos() {

        return await prisma.resultado.findMany({
            include: {
                partido: true,
                registrador: true
            }
        });

    }

    async obtenerPorId(id: number) {

        return await prisma.resultado.findUnique({
            where: {
                id_resultado: id
            },
            include: {
                partido: true,
                registrador: true
            }
        });

    }

    async obtenerPorPartido(id_partido: number) {

        return await prisma.resultado.findUnique({
            where: {
                id_partido
            }
        });

    }

    async crear(data: {
        id_partido: number;
        marcador_local?: number;
        marcador_visitante?: number;
        registrado_por: number;
    }) {

        return await prisma.resultado.create({
            data
        });

    }

    async actualizar(
        id: number,
        data: {
            marcador_local?: number;
            marcador_visitante?: number;
            registrado_por?: number;
        }
    ) {

        return await prisma.resultado.update({
            where: {
                id_resultado: id
            },
            data
        });

    }

    async eliminar(id: number) {

        return await prisma.resultado.delete({
            where: {
                id_resultado: id
            }
        });

    }

}