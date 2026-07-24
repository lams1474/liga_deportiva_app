import { ArbitroRepository } from "../repositories/arbitro.repository";

export class ArbitroService {

    private repository = new ArbitroRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
        categoria: string;
    }) {

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            categoria?: string;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}