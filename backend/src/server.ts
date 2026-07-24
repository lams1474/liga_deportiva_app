import app from './app';
import prisma from './config/prisma';

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
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