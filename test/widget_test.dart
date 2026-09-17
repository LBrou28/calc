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

  testWidgets('Addition: 2 + 2 = 4', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    expect(result(tester), '0');
    await press(tester, ['2', '+', '2', '=']);
    expect(result(tester), '4');
  });

  testWidgets('Subtraction: 9 - 3 = 6', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['9', '−', '3', '=']);
    expect(result(tester), '6');
  });

  testWidgets('Multiplication: 6 x 2 = 12', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['6', '×', '2', '=']);
    expect(result(tester), '12');
  });

  testWidgets('Division: 12 / 4 = 3', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['1', '2', '÷', '4', '=']);
    expect(result(tester), '3');
  });

  testWidgets('Clear: resets result and pending operation', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['9', '+', '3', 'AC']);
    expect(result(tester), '0');
    await press(tester, ['2', '=']);
    expect(result(tester), '2');
  });

  testWidgets('Input: decimal addition and duplicate decimal prevention',
      (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['1', '.', '.', '5', '+', '0', '.', '5', '=']);
    expect(result(tester), '2');
  });

  testWidgets('Input: backspace corrects the current number', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['1', '2', '⌫']);
    expect(result(tester), '1');
    await press(tester, ['⌫']);
    expect(result(tester), '0');
  });

  testWidgets('Input: division by zero displays Error and recovers',
      (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['2', '÷', '0', '=']);
    expect(result(tester), 'Error');
    await press(tester, ['4', '+', '2', '=']);
    expect(result(tester), '6');
  });

  testWidgets('Input: sign change produces a negative number', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, ['3', '±', '+', '1', '=']);
    expect(result(tester), '-2');
  });
}
