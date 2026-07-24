import { JugadorRepository } from "../repositories/jugador.repository";

export class JugadorService {

    private repository = new JugadorRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
        ciudad: string;
        fecha_nacimiento: Date;
        id_club: number;
    }) {

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            ciudad?: string;
            fecha_nacimiento?: Date;
            id_club?: number;
        }
    ) {

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        return await this.repository.eliminar(id);

    }

}