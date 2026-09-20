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
            const { cedula, nombre, ciudad, fecha_nacimiento, id_club, foto_path } = req.body;
            const errores: { campo: string; mensaje: string }[] = [];

            if (!cedula || cedula.toString().trim() === '') {
                errores.push({ campo: 'cedula', mensaje: 'La cédula es obligatoria' });
            }
            if (!nombre || nombre.trim() === '') {
                errores.push({ campo: 'nombre', mensaje: 'El nombre es obligatorio' });
            }
            if (!ciudad || ciudad.trim() === '') {
                errores.push({ campo: 'ciudad', mensaje: 'La ciudad es obligatoria' });
            }
            if (!fecha_nacimiento) {
                errores.push({ campo: 'fecha_nacimiento', mensaje: 'La fecha de nacimiento es obligatoria' });
            }
            if (!id_club) {
                errores.push({ campo: 'id_club', mensaje: 'El club es obligatorio' });
            }

            if (errores.length > 0) {
                return res.status(422).json({
                    mensaje: 'Los datos enviados no son válidos',
                    errores,
                });
            }

            const data = {
                cedula: cedula.toString(),
                nombre: nombre.trim(),
                ciudad: ciudad.trim(),
                fecha_nacimiento: new Date(fecha_nacimiento),
                id_club: Number(id_club),
                foto_path: foto_path ?? null,  // 🔥 NUEVO
            };

            const jugador = await this.service.crear(data);
            res.status(201).json(jugador);

        } catch (error: any) {
            if (error.message.includes('Unique constraint') ||
                error.message.includes('Jugador_cedula_key') ||
                error.code === 'P2002') {
                return res.status(422).json({
                    mensaje: 'La cédula ya está registrada',
                    errores: [
                        { campo: 'cedula', mensaje: 'La cédula ya está registrada en el sistema' },
                    ],
                });
            }

            if (error.message.includes('obligatorio') ||
                error.message.includes('inválido') ||
                error.message.includes('requerido')) {
                return res.status(422).json({
                    mensaje: error.message,
                    errores: [
                        { campo: 'general', mensaje: error.message },
                    ],
                });
            }

            res.status(400).json({
                mensaje: error.message,
            });
        }
    }

    async actualizar(req: Request, res: Response) {
        try {
            const id = Number(req.params.id);
            const { cedula, nombre, ciudad, fecha_nacimiento, id_club, foto_path } = req.body;
            const errores: { campo: string; mensaje: string }[] = [];

            if (!cedula || cedula.toString().trim() === '') {
                errores.push({ campo: 'cedula', mensaje: 'La cédula es obligatoria' });
            }
            if (!nombre || nombre.trim() === '') {
                errores.push({ campo: 'nombre', mensaje: 'El nombre es obligatorio' });
            }
            if (!ciudad || ciudad.trim() === '') {
                errores.push({ campo: 'ciudad', mensaje: 'La ciudad es obligatoria' });
            }

            if (errores.length > 0) {
                return res.status(422).json({
                    mensaje: 'Los datos enviados no son válidos',
                    errores,
                });
            }

            const data = {
                cedula: cedula.toString(),
                nombre: nombre.trim(),
                ciudad: ciudad.trim(),
                fecha_nacimiento: fecha_nacimiento ? new Date(fecha_nacimiento) : undefined,
                id_club: id_club ? Number(id_club) : undefined,
                foto_path: foto_path ?? null,  // 🔥 NUEVO
            };

            const jugador = await this.service.actualizar(id, data);
            res.json(jugador);

        } catch (error: any) {
            if (error.message.includes('no encontrado') || error.code === 'P2025') {
                return res.status(404).json({
                    mensaje: 'Jugador no encontrado',
                });
            }

            if (error.message.includes('Unique constraint') ||
                error.code === 'P2002') {
                return res.status(422).json({
                    mensaje: 'La cédula ya está registrada',
                    errores: [
                        { campo: 'cedula', mensaje: 'La cédula ya está registrada en el sistema' },
                    ],
                });
            }

            res.status(400).json({
                mensaje: error.message,
            });
        }
    }

    async eliminar(req: Request, res: Response) {
        try {
            const id = Number(req.params.id);
            await this.service.eliminar(id);
            res.json({
                mensaje: "Jugador eliminado correctamente."
            });
        } catch (error: any) {
            if (error.message.includes('no encontrado') || error.code === 'P2025') {
                return res.status(404).json({
                    mensaje: 'Jugador no encontrado',
                });
            }
            res.status(400).json({
                mensaje: error.message,
            });
        }
    }
}