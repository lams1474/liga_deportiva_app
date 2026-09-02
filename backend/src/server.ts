import app from './app';
import prisma from './config/prisma';

const PORT = parseInt(process.env.PORT || '3000', 10);

// CORREGIDO: Escucha en todas las interfaces (0.0.0.0)
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor corriendo en http://0.0.0.0:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`📱 Acceso desde otros dispositivos: http://[TU_IP]:${PORT}/health`);
});

// Cierre graceful
process.on('SIGTERM', async () => {
  console.log('🔴 Cerrando servidor...');
  await prisma.$disconnect();
  server.close(() => {
    console.log('✅ Servidor cerrado');
    process.exit(0);
  });
});

export default server;