import { PartidoRepository } from "../repositories/partido.repository";

export class PartidoService {

    private repository = new PartidoRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        fecha: Date;
        hora: string;
        lugar: string;
        id_categoria: number;
        id_club_local: number;
        id_club_visitante: number;
        id_temporada: number;
        id_arbitro: number;
        programado_por: number;
    }) {

        if (data.id_club_local === data.id_club_visitante) {
            throw new Error("El club local y el club visitante no pueden ser el mismo.");
        }

        return await this.repository.crear(data);

    }

    async actualizar(
        id: number,
        data: {
            fecha?: Date;
            hora?: string;
            lugar?: string;
            id_categoria?: number;
            id_club_local?: number;
            id_club_visitante?: number;
            id_temporada?: number;
            id_arbitro?: number;
            programado_por?: number;
        }
    ) {

        if (
            data.id_club_local &&
            data.id_club_visitante &&
            data.id_club_local === data.id_club_visitante
        ) {
            throw new Error("El club local y el club visitante no pueden ser el mismo.");
        }

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {
        return await this.repository.eliminar(id);
    }

}