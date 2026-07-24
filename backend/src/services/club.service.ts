import { ClubRepository } from "../repositories/club.repository";

export class ClubService {

    private repository = new ClubRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
        ciudad: string;
        fecha_fundacion?: Date;
    }) {

        const existe = await this.repository.obtenerPorNombre(data.nombre);

        if (existe) {
            throw new Error("El club ya está registrado.");
        }

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            ciudad?: string;
            fecha_fundacion?: Date;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}