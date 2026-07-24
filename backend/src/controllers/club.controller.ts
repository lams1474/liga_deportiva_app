import { Request, Response } from "express";
import { ClubService } from "../services/club.service";

export class ClubController {

    private service = new ClubService();

    async obtenerTodos(req: Request, res: Response) {

        const clubes = await this.service.obtenerTodos();

        res.json(clubes);

    }

    async obtenerPorId(req: Request, res: Response) {

        const id = Number(req.params.id);

        const club = await this.service.obtenerPorId(id);

        res.json(club);

    }

    async crear(req: Request, res: Response) {

        try {

            const data = {
                ...req.body,
                fecha_fundacion: req.body.fecha_fundacion
                    ? new Date(req.body.fecha_fundacion)
                    : undefined
            };

            const club = await this.service.crear(data);

            res.status(201).json(club);

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
            fecha_fundacion: req.body.fecha_fundacion
                ? new Date(req.body.fecha_fundacion)
                : undefined
        };

        const club = await this.service.actualizar(id, data);

        res.json(club);

    }

    async eliminar(req: Request, res: Response) {

        const id = Number(req.params.id);

        await this.service.eliminar(id);

        res.json({
            mensaje: "Club eliminado correctamente."
        });

    }

}