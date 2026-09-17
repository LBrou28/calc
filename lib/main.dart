import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB9F36B),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111411),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _left;
  String? _operator;
  bool _newEntry = true;

  String _format(double value) {
    if (!value.isFinite) return 'Error';
    return double.parse(value.toStringAsPrecision(12))
        .toString()
        .replaceFirst(RegExp(r'\.0$'), '');
  }

  void _calculate() {
    final right = double.tryParse(_display);
    if (_left == null || _operator == null || right == null) return;
    final value = switch (_operator) {
      '+' => _left! + right,
      '−' => _left! - right,
      '×' => _left! * right,
      '÷' => _left! / right,
      _ => right,
    };
    _display = _format(value);
    _left = null;
    _operator = null;
    _newEntry = true;
  }

  void _press(String key) {
    setState(() {
      if (key == 'AC') {
        _display = '0';
        _left = null;
        _operator = null;
        _newEntry = true;
      } else if (key == '⌫') {
        if (_newEntry) return;
        _display = _display.length > 1
            ? _display.substring(0, _display.length - 1)
            : '0';
        if (_display == '-') _display = '0';
      } else if (key == '±') {
        if (_display == 'Error' || _display == '0') return;
        _display =
            _display.startsWith('-') ? _display.substring(1) : '-$_display';
      } else if (['+', '−', '×', '÷'].contains(key)) {
        if (_display == 'Error') return;
        if (!_newEntry) _calculate();
        _left = double.tryParse(_display);
        _operator = _left == null ? null : key;
        _newEntry = true;
      } else if (key == '=') {
        if (!_newEntry) _calculate();
      } else {
        if (_newEntry || _display == 'Error') {
          _display = key == '.' ? '0.' : key;
          _newEntry = false;
        } else if (key == '.') {
          if (!_display.contains('.')) _display += '.';
        } else if (_display.replaceAll(RegExp(r'[-.]'), '').length < 12) {
          _display = _display == '0' ? key : '$_display$key';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['AC', '±', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'CALC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _left == null
                        ? 'Ready when you are'
                        : '${_format(_left!)} $_operator',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFFACB5A7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 88,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        key: const Key('result'),
                        semanticsLabel: 'Result: $_display',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          for (var i = 0; i < row.length; i++) ...[
                            if (i > 0) const SizedBox(width: 10),
                            Expanded(
                              flex: row[i] == '0' ? 2 : 1,
                              child: SizedBox(
                                height: 64,
                                child: FilledButton(
                                  key: Key('key_${row[i]}'),
                                  onPressed: () => _press(row[i]),
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: row[i] == '='
                                        ? const Color(0xFFB9F36B)
                                        : ['+', '−', '×', '÷'].contains(row[i])
                                            ? const Color(0xFF34442A)
                                            : const Color(0xFF252B24),
                                    foregroundColor: row[i] == '='
                                        ? Colors.black
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    textStyle: const TextStyle(fontSize: 24),
                                  ),
                                  child: Text(row[i]),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
