import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panc_smart/screens/auth/register_screen.dart';
import 'package:panc_smart/screens/auth/forgot_password_screen.dart';

void main() {
  testWidgets('Register screen renders on phone and tablet without overflow',
      (WidgetTester tester) async {
    // phone
    tester.binding.window.physicalSizeTestValue = const Size(360, 780);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Criar Conta'), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);

    // tablet
    tester.binding.window.physicalSizeTestValue = const Size(1024, 1366);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Criar Conta'), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);

    // cleanup
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
  });

  testWidgets('Forgot password renders on phone and tablet without overflow',
      (WidgetTester tester) async {
    // phone
    tester.binding.window.physicalSizeTestValue = const Size(360, 780);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Recuperar Senha'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);

    // tablet
    tester.binding.window.physicalSizeTestValue = const Size(1024, 1366);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Recuperar Senha'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);

    // cleanup
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
  });
}
