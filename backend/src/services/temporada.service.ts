import { TemporadaRepository } from "../repositories/temporada.repository";

export class TemporadaService {

    private repository = new TemporadaRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        año: number;
    }) {

        const existe = await this.repository.obtenerPorAnio(data.año);

        if (existe) {
            throw new Error("La temporada ya está registrada.");
        }

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            año?: number;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}