import prisma from "./config/prisma";

async function main() {
  const usuarios = await prisma.usuario.findMany();

  console.log("Conexión correcta.");
  console.log(usuarios);
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
  });