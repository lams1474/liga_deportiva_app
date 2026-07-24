import { UsuarioRepository } from "../repositories/usuario.repository";

export class UsuarioService {

    private repository = new UsuarioRepository();

    async obtenerTodos() {
        return await this.repository.obtenerTodos();
    }

    async obtenerPorId(id: number) {
        return await this.repository.obtenerPorId(id);
    }

    async crear(data: {
        nombre: string;
        correo: string;
        contrasena: string;
        rol: string;
    }) {

        const existe = await this.repository.obtenerPorCorreo(data.correo);

        if (existe) {
            throw new Error("El correo ya está registrado.");
        }

        return await this.repository.crear(data);
    }

    async actualizar(
        id: number,
        data: {
            nombre?: string;
            correo?: string;
            contrasena?: string;
            rol?: string;
        }
    ) {

        const usuario = await this.repository.obtenerPorId(id);

        if (!usuario) {
            throw new Error("Usuario no encontrado.");
        }

        return await this.repository.actualizar(id, data);

    }

    async eliminar(id: number) {

        const usuario = await this.repository.obtenerPorId(id);

        if (!usuario) {
            throw new Error("Usuario no encontrado.");
        }

        return await this.repository.eliminar(id);

    }

}