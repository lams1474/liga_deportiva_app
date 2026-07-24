import { Request, Response } from "express";
import { CategoriaService } from "../services/categoria.service";

export class CategoriaController {

    private service = new CategoriaService();

    async obtenerTodos(req: Request, res: Response) {

        const categorias = await this.service.obtenerTodos();

        res.json(categorias);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const categoria = await this.service.obtenerPorId(id);

        res.json(categoria);

    }

    async crear(req: Request, res: Response) {

        try {

            const categoria = await this.service.crear(req.body);

            res.status(201).json(categoria);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        const id = Number(req.params.id);

        const categoria = await this.service.actualizar(id, req.body);

        res.json(categoria);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Categoría eliminada correctamente."
        });

    }

}