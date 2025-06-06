import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_002_weather_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Weather App'), findsOneWidget);
  });
}

