import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff0f0f1a),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String input = "";
  String output = "0";

  void buttonPressed(String value) {

    setState(() {

      if (value == "C") {
        input = "";
        output = "0";
      }

      else if (value == "⌫") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      }

      else if (value == "=") {
        if (input.isEmpty) return;
        output = calculate(input);
      }

      else {

        if ("+-*/".contains(value)) {

          if (input.isEmpty) return;

          String last = input[input.length - 1];

          if ("+-*/".contains(last)) return;
        }

        input += value;
      }

    });

  }

  String calculate(String expression) {

    try {

      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(expression);

      ContextModel cm = ContextModel();

      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result % 1 == 0) {
        return result.toInt().toString();
      }

      return result.toString();

    } catch (e) {
      return "Error";
    }
  }

  Widget buildButton(String text, Color color) {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => buttonPressed(text),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.9),
                  color
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(3,3),
                )
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff6a3cbc),
        elevation: 0,
      ),

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1e1e2f),
              Color(0xff0f0f1a),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(

          child: Column(

            children: [

              const SizedBox(height: 15),

              /// INPUT DISPLAY
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.06),
                ),
                child: Text(
                  input.isEmpty ? "0" : input,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// RESULT DISPLAY
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.10),
                ),
                child: Text(
                  output,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// BUTTON AREA
              Expanded(

                child: Column(

                  children: [

                    Row(
                      children: [
                        buildButton("C", Colors.redAccent),
                        buildButton("⌫", Colors.orange),
                        buildButton("/", Colors.deepPurple),
                        buildButton("*", Colors.deepPurple),
                      ],
                    ),

                    Row(
                      children: [
                        buildButton("7", Colors.grey.shade800),
                        buildButton("8", Colors.grey.shade800),
                        buildButton("9", Colors.grey.shade800),
                        buildButton("-", Colors.deepPurple),
                      ],
                    ),

                    Row(
                      children: [
                        buildButton("4", Colors.grey.shade800),
                        buildButton("5", Colors.grey.shade800),
                        buildButton("6", Colors.grey.shade800),
                        buildButton("+", Colors.deepPurple),
                      ],
                    ),

                    Row(
                      children: [
                        buildButton("1", Colors.grey.shade800),
                        buildButton("2", Colors.grey.shade800),
                        buildButton("3", Colors.grey.shade800),
                        buildButton("=", Colors.green),
                      ],
                    ),

                    Row(
                      children: [
                        buildButton("0", Colors.grey.shade800),
                        buildButton(".", Colors.grey.shade800),
                      ],
                    ),

                  ],
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}