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
            const { nombre, ciudad, presidente, fecha_fundacion, latitud, longitud, precision_ubicacion } = req.body;
            const errores: { campo: string; mensaje: string }[] = [];

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
                nombre: nombre.trim(),
                ciudad: ciudad.trim(),
                presidente: presidente?.trim() || null,           // 🔥 NUEVO
                fecha_fundacion: fecha_fundacion
                    ? new Date(fecha_fundacion)
                    : undefined,
                latitud: latitud != null ? Number(latitud) : null,        // 🔥 NUEVO
                longitud: longitud != null ? Number(longitud) : null,     // 🔥 NUEVO
                precision_ubicacion: precision_ubicacion ?? null,         // 🔥 NUEVO
            };

            const club = await this.service.crear(data);
            res.status(201).json(club);

        } catch (error: any) {
            if (error.message.includes('ya está registrado') ||
                error.message.includes('duplicate') ||
                error.message.includes('unique')) {
                return res.status(422).json({
                    mensaje: error.message,
                    errores: [
                        { campo: 'nombre', mensaje: 'El nombre del club ya existe' },
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
            const { nombre, ciudad, presidente, fecha_fundacion, latitud, longitud, precision_ubicacion } = req.body;
            const errores: { campo: string; mensaje: string }[] = [];

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
                nombre: nombre.trim(),
                ciudad: ciudad.trim(),
                presidente: presidente?.trim() || null,           // 🔥 NUEVO
                fecha_fundacion: fecha_fundacion
                    ? new Date(fecha_fundacion)
                    : undefined,
                latitud: latitud != null ? Number(latitud) : null,        // 🔥 NUEVO
                longitud: longitud != null ? Number(longitud) : null,     // 🔥 NUEVO
                precision_ubicacion: precision_ubicacion ?? null,         // 🔥 NUEVO
            };

            const club = await this.service.actualizar(id, data);
            res.json(club);

        } catch (error: any) {
            if (error.message.includes('no encontrado')) {
                return res.status(404).json({
                    mensaje: error.message,
                });
            }

            if (error.message.includes('ya está registrado') ||
                error.message.includes('duplicate') ||
                error.message.includes('unique')) {
                return res.status(422).json({
                    mensaje: error.message,
                    errores: [
                        { campo: 'nombre', mensaje: 'El nombre del club ya existe' },
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
                mensaje: "Club eliminado correctamente."
            });
        } catch (error: any) {
            if (error.message.includes('no encontrado')) {
                return res.status(404).json({
                    mensaje: error.message,
                });
            }
            res.status(400).json({
                mensaje: error.message,
            });
        }
    }
}