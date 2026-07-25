import { JugadorDisciplinaRepository } from "../repositories/jugadorDisciplina.repository";

export class JugadorDisciplinaService {

    private repository = new JugadorDisciplinaRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id_jugador: number, id_disciplina: number) {
        return await this.repository.obtenerPorId(id_jugador, id_disciplina);
    }

    async crear(data: {
        id_jugador: number;
        id_disciplina: number;
    }) {

        return await this.repository.crear(data);

    }

    async eliminar(id_jugador: number, id_disciplina: number) {

        return await this.repository.eliminar(id_jugador, id_disciplina);

    }

}