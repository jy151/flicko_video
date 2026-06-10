import 'package:flicko_video/page/create_result/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Create result page shows generation progress', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: CreateResultView())),
    );
    await tester.pump();

    expect(find.text('Create AI Video'), findsOneWidget);
    expect(find.text('Estimated wait: 2 min'), findsOneWidget);
    expect(find.text('1%'), findsOneWidget);
    expect(find.text('Re-edit'), findsOneWidget);
    expect(find.text('Continue\nCreating'), findsOneWidget);
    expect(find.text('My Creations'), findsOneWidget);
  });
}
