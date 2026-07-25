import { Request, Response } from "express";
import { TablaPosicionesService } from "../services/tablaPosiciones.service";

export class TablaPosicionesController {

    private service = new TablaPosicionesService();

    async obtenerTodos(req: Request, res: Response) {

        const posiciones = await this.service.obtenerTodos();

        res.json(posiciones);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const posicion = await this.service.obtenerPorId(id);

        res.json(posicion);

    }

    async crear(req: Request, res: Response) {

        try {

            const posicion = await this.service.crear(req.body);

            res.status(201).json(posicion);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            const posicion = await this.service.actualizar(id, req.body);

            res.json(posicion);

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
            mensaje: "Registro de tabla de posiciones eliminado correctamente."
        });

    }

}