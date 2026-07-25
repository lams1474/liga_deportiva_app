import { Request, Response } from "express";
import { ResultadoService } from "../services/resultado.service";

export class ResultadoController {

    private service = new ResultadoService();

    async obtenerTodos(req: Request, res: Response) {

        const resultados = await this.service.obtenerTodos();

        res.json(resultados);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const resultado = await this.service.obtenerPorId(id);

        res.json(resultado);

    }

    async crear(req: Request, res: Response) {

        try {

            const resultado = await this.service.crear(req.body);

            res.status(201).json(resultado);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            const resultado = await this.service.actualizar(id, req.body);

            res.json(resultado);

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
            mensaje: "Resultado eliminado correctamente."
        });

    }

}