import { DisciplinaRepository } from "../repositories/disciplina.repository";

export class DisciplinaService {

    private repository = new DisciplinaRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
    }) {

        const existe = await this.repository.obtenerPorNombre(data.nombre);

        if (existe) {
            throw new Error("La disciplina ya existe.");
        }

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}