import { Request, Response } from "express";
import { UsuarioService } from "../services/usuario.service";

export class UsuarioController {

    private service = new UsuarioService();

    async obtenerTodos(req: Request, res: Response) {

        try {

            const usuarios = await this.service.obtenerTodos();

            res.json(usuarios);

        } catch (error: any) {

            res.status(500).json({
                mensaje: error.message
            });

        }

    }

    async obtenerPorId(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            const usuario = await this.service.obtenerPorId(id);

            if (!usuario) {
                return res.status(404).json({
                    mensaje: "Usuario no encontrado."
                });
            }

            res.json(usuario);

        } catch (error: any) {

            res.status(500).json({
                mensaje: error.message
            });

        }

    }

    async crear(req: Request, res: Response) {

        try {

            const usuario = await this.service.crear(req.body);

            res.status(201).json(usuario);

        } catch (error: any) {

            res.status(400).json({
                mensaje: error.message
            });

        }

    }

    async actualizar(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            const usuario = await this.service.actualizar(id, req.body);

            res.json(usuario);

        } catch (error: any) {

            res.status(404).json({
                mensaje: error.message
            });

        }

    }

    async eliminar(req: Request, res: Response) {

        try {

            const id = Number(req.params.id);

            await this.service.eliminar(id);

            res.json({
                mensaje: "Usuario eliminado correctamente."
            });

        } catch (error: any) {

            res.status(404).json({
                mensaje: error.message
            });

        }

    }

}