import { PrismaClient } from '../src/generated/prisma';
import * as bcrypt from 'bcryptjs';  // 🔥 Cambiado de 'bcrypt' a 'bcryptjs'

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed...');

  // Hash de la contraseña "654321"
  const contrasenaHash = await bcrypt.hash('654321', 10);

  // Crear usuario admin
  const admin = await prisma.usuario.upsert({
    where: { correo: 'admin@liga.com' },
    update: {},
    create: {
      nombre: 'Administrador General',
      correo: 'admin@liga.com',
      contrasena: contrasenaHash,
      rol: 'SUPER_ADMIN',
    },
  });

  console.log('✅ Usuario admin creado:', admin.correo);

  // Crear algunos clubes de ejemplo
  const club1 = await prisma.club.upsert({
    where: { nombre: 'Club Deportivo Spartanos FC' },
    update: {},
    create: {
      nombre: 'Club Deportivo Spartanos FC',
      ciudad: 'Pujilí',
      fecha_fundacion: new Date('2012-05-05'),
    },
  });
  console.log('✅ Club creado:', club1.nombre);

  const club2 = await prisma.club.upsert({
    where: { nombre: 'Liga Deportiva Pujilí' },
    update: {},
    create: {
      nombre: 'Liga Deportiva Pujilí',
      ciudad: 'Pujilí',
      fecha_fundacion: new Date('2020-01-15'),
    },
  });
  console.log('✅ Club creado:', club2.nombre);

  // Crear algunos jugadores de ejemplo
  const jugador1 = await prisma.jugador.create({
    data: {
      cedula: '0502067001',
      nombre: 'Luis Alfonso Maigua Sisalema',
      ciudad: 'Pujilí',
      fecha_nacimiento: new Date('1974-01-14'),
      id_club: club1.id_club,
    },
  });
  console.log('✅ Jugador creado:', jugador1.nombre);

  const jugador2 = await prisma.jugador.create({
    data: {
      cedula: '0502067002',
      nombre: 'María José Pérez',
      ciudad: 'Latacunga',
      fecha_nacimiento: new Date('1990-05-20'),
      id_club: club2.id_club,
    },
  });
  console.log('✅ Jugador creado:', jugador2.nombre);

  console.log('🎉 Seed completado exitosamente!');
}

main()
  .catch((e) => {
    console.error('❌ Error en seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });