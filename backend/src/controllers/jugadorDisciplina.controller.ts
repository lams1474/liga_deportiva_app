import { Request, Response } from "express";
import { JugadorDisciplinaService } from "../services/jugadorDisciplina.service";

export class JugadorDisciplinaController {

    private service = new JugadorDisciplinaService();

    async obtenerTodos(req: Request, res: Response) {

        try {

            const relaciones = await this.service.obtenerTodos();

            res.json(relaciones);

        } catch (error: any) {

            res.status(500).json({
                mensaje: error.message
            });

        }

    }

    async obtenerPorId(req: Request, res: Response) {

        try {

            const id_jugador = Number(req.params.id_jugador);
            const id_disciplina = Number(req.params.id_disciplina);

            const relacion = await this.service.obtenerPorId(
                id_jugador,
                id_disciplina
            );

            if (!relacion) {
                return res.status(404).json({
                    mensaje: "La relación jugador-disciplina no existe."
                });
            }

            res.json(relacion);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async crear(req: Request, res: Response) {

        try {

            const data = {
                id_jugador: Number(req.body.id_jugador),
                id_disciplina: Number(req.body.id_disciplina)
            };

            const relacion = await this.service.crear(data);

            res.status(201).json(relacion);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async eliminar(req: Request, res: Response) {

        try {

            const id_jugador = Number(req.params.id_jugador);
            const id_disciplina = Number(req.params.id_disciplina);

            await this.service.eliminar(
                id_jugador,
                id_disciplina
            );

            res.json({
                mensaje: "Disciplina del jugador eliminada correctamente."
            });

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

}