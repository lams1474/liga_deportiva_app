import { TablaPosicionesRepository } from "../repositories/tablaPosiciones.repository";
import cacheService from "./cache.service";

export class TablaPosicionesService {

    private repository = new TablaPosicionesRepository();

    private readonly CACHE_KEY = "tabla-posiciones";

    async obtenerTodos() {

        // 1. Revisar si existe información en caché
        const datosCache = cacheService.obtener<any[]>(this.CACHE_KEY);

        if (datosCache) {
            console.log("🟢 CACHE HIT - Tabla de posiciones");
            return datosCache;
        }

        // 2. Si no existe, consultar la base de datos
        console.log("🟡 CACHE MISS - Consultando base de datos");

        const datos = await this.repository.obtenerTodos();

        // 3. Guardar el resultado en caché
        cacheService.guardar(this.CACHE_KEY, datos);

        console.log("💾 Datos guardados en caché");

        return datos;
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        id_temporada: number;
        id_club: number;
        puntos: number;
        pj: number;
        pg: number;
        pe: number;
        pp: number;
        gf: number;
        gc: number;
    }) {

        const resultado = await this.repository.crear(data);

        // Invalidar caché después de crear
        cacheService.eliminar(this.CACHE_KEY);

        console.log("🗑️ Caché invalidada después de crear");

        return resultado;
    }

    async actualizar(
        id: number,
        data: {
            puntos?: number;
            pj?: number;
            pg?: number;
            pe?: number;
            pp?: number;
            gf?: number;
            gc?: number;
        }
    ) {

        const resultado = await this.repository.actualizar(id, data);

        // Invalidar caché después de actualizar
        cacheService.eliminar(this.CACHE_KEY);

        console.log("🗑️ Caché invalidada después de actualizar");

        return resultado;
    }

    async eliminar(id: number) {

        const resultado = await this.repository.eliminar(id);

        // Invalidar caché después de eliminar
        cacheService.eliminar(this.CACHE_KEY);

        console.log("🗑️ Caché invalidada después de eliminar");

        return resultado;
    }
}