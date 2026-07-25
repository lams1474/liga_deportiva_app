import { TablaPosicionesRepository } from "../repositories/tablaPosiciones.repository";

export class TablaPosicionesService {

    private repository = new TablaPosicionesRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
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

        return await this.repository.crear(data);

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

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}