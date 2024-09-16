import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_interview/src/presentation/post_list_screen.dart';
import 'package:fudo_interview/src/presentation/login_screen.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('Check initial UI state', (WidgetTester tester) async {
      // Build LoginScreen
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Verify the presence of the username and password fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify the presence of the login button by finding the ElevatedButton containing the "Login" text
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });
    testWidgets('Form validation - empty username and password',
        (WidgetTester tester) async {
      // Build LoginScreen
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Tap the login button without entering any input
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild UI after form submission

      // Check if validation errors appear
      expect(find.text('Please enter username'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });

    testWidgets('Successful login', (WidgetTester tester) async {
      // Build LoginScreen

      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          navigatorObservers: [mockObserver], // Attach the mock observer
        ),
      );
      // Enter valid credentials
      await tester.enterText(
          find.byType(TextFormField).at(0), 'challenge@fudo');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');

      // Tap the login button
      await tester.tap(find.byType(ElevatedButton));

      verify(mockObserver.navigator?.canPop());
    });
    testWidgets('Unsuccessful login - invalid credentials',
        (WidgetTester tester) async {
      // Build LoginScreen
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Enter invalid credentials
      await tester.enterText(find.byType(TextFormField).at(0), 'wrong@fudo');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');

      // Tap the login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild UI after form submission

      // Check for the error message
      expect(find.text('Invalid username or password'), findsOneWidget);
    });
  });
}
