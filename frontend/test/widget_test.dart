import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets(
    'La pantalla de inicio de sesión se muestra correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(const LigaDeportivaApp());

      await tester.pumpAndSettle();

      expect(
        find.text('Liga Deportiva Barrial'),
        findsNWidgets(2),
      );

      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Iniciar sesión'), findsOneWidget);
    },
  );
}