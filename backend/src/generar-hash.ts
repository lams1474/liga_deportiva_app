import bcrypt from "bcryptjs";

const contrasena = "654321";

async function generarHash() {
    const hash = await bcrypt.hash(contrasena, 10);

    console.log("Contraseña:", contrasena);
    console.log("Hash:", hash);
}

generarHash();