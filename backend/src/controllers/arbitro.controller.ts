import { Request, Response } from "express";
import { ArbitroService } from "../services/arbitro.service";

export class ArbitroController {

    private service = new ArbitroService();

    async obtenerTodos(req: Request, res: Response) {

        const arbitros = await this.service.obtenerTodos();

        res.json(arbitros);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const arbitro = await this.service.obtenerPorId(id);

        res.json(arbitro);

    }

    async crear(req: Request, res: Response) {

        try {

            const arbitro = await this.service.crear(req.body);

            res.status(201).json(arbitro);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        const id = Number(req.params.id);

        const arbitro = await this.service.actualizar(id, req.body);

        res.json(arbitro);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Árbitro eliminado correctamente."
        });

    }

}