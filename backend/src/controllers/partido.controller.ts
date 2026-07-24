import { Request, Response } from "express";
import { PartidoService } from "../services/partido.service";

export class PartidoController {

    private service = new PartidoService();

    async obtenerTodos(req: Request, res: Response) {

        const partidos = await this.service.obtenerTodos();

        res.json(partidos);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const partido = await this.service.obtenerPorId(id);

        res.json(partido);

    }

    async crear(req: Request, res: Response) {

        try {

            const data = {
                ...req.body,
                fecha: new Date(req.body.fecha)
            };

            const partido = await this.service.crear(data);

            res.status(201).json(partido);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            const data = {
                ...req.body,
                fecha: req.body.fecha
                    ? new Date(req.body.fecha)
                    : undefined
            };

            const partido = await this.service.actualizar(id, data);

            res.json(partido);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Partido eliminado correctamente."
        });

    }

}