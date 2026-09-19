class ApiConfig {
  // 🔥 Valores por defecto para desarrollo local
  static const String _defaultApiUrl = 'http://192.168.1.6:3000/api';
  static const String _defaultEnvironment = 'dev';

  // 🔥 Configuración desde --dart-define
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: _defaultApiUrl,
  );

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: _defaultEnvironment,
  );

  // 🔥 Getters de conveniencia
  static bool get isDevelopment => environment == 'dev';
  static bool get isProduction => environment == 'prod';
  static bool get isTesting => environment == 'test';

  // 🔥 Timeouts configurables
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // 🔥 Habilitar logs solo en desarrollo
  static bool get enableLogs => isDevelopment;

  // 🔥 Método para mostrar la configuración actual
  static void printConfig() {
    print('🌐 API Config:');
    print('   URL: $apiUrl');
    print('   Ambiente: $environment');
    print('   Connect Timeout: ${connectTimeout.inSeconds}s');
    print('   Receive Timeout: ${receiveTimeout.inSeconds}s');
    print('   Logs habilitados: $enableLogs');
  }
}