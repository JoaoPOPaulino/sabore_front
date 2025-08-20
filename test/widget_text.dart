import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/main.dart'; // Certifique-se de que o caminho está correto

void main() {
  testWidgets('Onboarding screen is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the onboarding screen is displayed.
    expect(find.text('Saborê'), findsOneWidget); // Verifica o texto "Saborê" na tela de onboarding
    expect(find.byType(PageView), findsOneWidget); // Verifica se a PageView está presente
  });
}