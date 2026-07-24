import { CategoriaRepository } from "../repositories/categoria.repository";

export class CategoriaService {

    private repository = new CategoriaRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
        id_disciplina: number;
    }) {

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            id_disciplina?: number;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}