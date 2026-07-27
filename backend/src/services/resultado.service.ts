import { ResultadoRepository } from "../repositories/resultado.repository";
import { resultadoWorker } from "../workers/resultado.worker";

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

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {
        return await this.repository.eliminar(id);
    }

}