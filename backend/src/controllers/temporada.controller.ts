import { Request, Response } from "express";
import { TemporadaService } from "../services/temporada.service";

export class TemporadaController {

    private service = new TemporadaService();

    async obtenerTodos(req: Request, res: Response) {

        const temporadas = await this.service.obtenerTodos();

        res.json(temporadas);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const temporada = await this.service.obtenerPorId(id);

        res.json(temporada);

    }

    async crear(req: Request, res: Response) {

        try {

            const temporada = await this.service.crear(req.body);

            res.status(201).json(temporada);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        const id = Number(req.params.id);

        const temporada = await this.service.actualizar(id, req.body);

        res.json(temporada);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Temporada eliminada correctamente."
        });

    }

}