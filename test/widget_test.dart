import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_vibecode_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:my_vibecode_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_vibecode_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_vibecode_app/features/auth/presentation/pages/login_screen.dart';

void main() {
  testWidgets('login screen submits credentials', (WidgetTester tester) async {
    final useCase = LoginUseCase(
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
    );
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(loginUseCase: useCase)),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Welcome, Demo User'), findsOneWidget);
  });
}
