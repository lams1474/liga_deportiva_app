import { ResultadoRepository } from "../repositories/resultado.repository";
import { resultadoWorker } from "../workers/resultado.worker";
import prisma from "../config/prisma";

export class ResultadoService {

    private repository = new ResultadoRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        id_partido: number;
        marcador_local?: number;
        marcador_visitante?: number;
        registrado_por: number;
    }) {

        const existe = await this.repository.obtenerPorPartido(data.id_partido);

        if (existe) {
            throw new Error("El resultado para este partido ya fue registrado.");
        }

        const resultado = await this.repository.crear(data);

        // 🔥 Ejecutar worker para recalcular la tabla
        resultadoWorker.agregarTarea({
            id_resultado: resultado.id_resultado,
            id_partido: resultado.id_partido
        });

        return resultado;
    }

    async actualizar(
        id: number,
        data: {
            marcador_local?: number;
            marcador_visitante?: number;
            registrado_por?: number;
        }
    ) {

        const resultado = await this.repository.actualizar(id, data);

        // 🔥 Ejecutar worker para recalcular la tabla
        resultadoWorker.agregarTarea({
            id_resultado: resultado.id_resultado,
            id_partido: resultado.id_partido
        });

        return resultado;
    }

    async eliminar(id: number) {

        // 1. Obtener el resultado antes de eliminarlo (para saber el partido)
        const resultado = await prisma.resultado.findUnique({
            where: { id_resultado: id }
        });

        if (!resultado) {
            throw new Error("Resultado no encontrado.");
        }

        // 2. Eliminar el resultado
        const eliminado = await this.repository.eliminar(id);

        // 3. Ejecutar worker para recalcular la tabla (sin el resultado eliminado)
        resultadoWorker.agregarTarea({
            id_resultado: eliminado.id_resultado,
            id_partido: resultado.id_partido
        });

        return eliminado;
    }
}