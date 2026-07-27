import NodeCache from "node-cache";

class CacheService {

    private cache: NodeCache;

    constructor() {
        // TTL de 60 segundos
        // checkperiod de 120 segundos
        this.cache = new NodeCache({
            stdTTL: 60,
            checkperiod: 120
        });
    }

    obtener<T>(clave: string): T | undefined {
        return this.cache.get<T>(clave);
    }

    guardar<T>(clave: string, valor: T): void {
        this.cache.set(clave, valor);
    }

    eliminar(clave: string): void {
        this.cache.del(clave);
    }

    limpiar(): void {
        this.cache.flushAll();
    }
}

export default new CacheService();