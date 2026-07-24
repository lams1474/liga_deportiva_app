import prisma from './config/prisma';

async function testConnection() {
  console.log('🔍 Iniciando prueba de conexión...');
  
  try {
    console.log('⏳ Conectando a MySQL...');
    await prisma.$connect();
    console.log('✅ Conectado a MySQL correctamente');
    
    console.log('⏳ Contando usuarios...');
    const userCount = await prisma.usuario.count();
    console.log(`📊 Usuarios en la base de datos: ${userCount}`);
    
    console.log('🎉 Prueba completada con éxito!');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
    console.log('🔌 Conexión cerrada');
  }
}

testConnection();
