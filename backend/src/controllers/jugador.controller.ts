import { Request, Response } from "express";
import { JugadorService } from "../services/jugador.service";

export class JugadorController {

    private service = new JugadorService();

    async obtenerTodos(req: Request, res: Response) {

        const jugadores = await this.service.obtenerTodos();

        res.json(jugadores);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const jugador = await this.service.obtenerPorId(id);

        res.json(jugador);

    }

    async crear(req: Request, res: Response) {

        try {

            const data = {
                ...req.body,
                fecha_nacimiento: req.body.fecha_nacimiento
                    ? new Date(req.body.fecha_nacimiento)
                    : undefined
            };

            const jugador = await this.service.crear(data);

            res.status(201).json(jugador);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        const id = Number(req.params.id);

        const data = {
            ...req.body,
            fecha_nacimiento: req.body.fecha_nacimiento
                ? new Date(req.body.fecha_nacimiento)
                : undefined
        };

        const jugador = await this.service.actualizar(id, data);

        res.json(jugador);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Jugador eliminado correctamente."
        });

    }

}