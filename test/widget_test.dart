import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_has_app/main.dart';
import 'package:smart_has_app/screens/login_screen.dart';

void main() {
  testWidgets('Displays LoginScreen after SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}