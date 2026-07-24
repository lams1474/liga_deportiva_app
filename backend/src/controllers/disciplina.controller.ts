import { Request, Response } from "express";
import { DisciplinaService } from "../services/disciplina.service";

export class DisciplinaController {

    private service = new DisciplinaService();

    async obtenerTodos(req: Request, res: Response) {

        const disciplinas = await this.service.obtenerTodos();

        res.json(disciplinas);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const disciplina = await this.service.obtenerPorId(id);

        res.json(disciplina);

    }

    async crear(req: Request, res: Response) {

        try {

            const disciplina = await this.service.crear(req.body);

            res.status(201).json(disciplina);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        const id = Number(req.params.id);

        const disciplina = await this.service.actualizar(id, req.body);

        res.json(disciplina);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Disciplina eliminada correctamente."
        });

    }

}