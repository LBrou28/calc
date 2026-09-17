import 'package:calc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> press(WidgetTester tester, List<String> keys) async {
    for (final key in keys) {
      await tester.tap(find.byKey(Key('key_$key')));
      await tester.pump();
    }
  }

  String result(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('result'))).data!;

  testWidgets('Start calculator, add 2 + 2, and check 4', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    expect(result(tester), '0');
    await press(tester, ['2', '+', '2', '=']);
    expect(result(tester), '4');
  });

  testWidgets('Supports subtraction, multiplication, division, and clearing', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['9', '−', '3', '=']);
    expect(result(tester), '6');
    await press(tester, ['×', '2', '=']);
    expect(result(tester), '12');
    await press(tester, ['÷', '4', '=']);
    expect(result(tester), '3');
    await press(tester, ['AC']);
    expect(result(tester), '0');
  });

  testWidgets('Handles decimals, correction, and division by zero', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['1', '2', '⌫', '.', '5', '+', '0', '.', '5', '=']);
    expect(result(tester), '2');
    await press(tester, ['÷', '0', '=']);
    expect(result(tester), 'Error');
    await press(tester, ['4']);
    expect(result(tester), '4');
  });
}
