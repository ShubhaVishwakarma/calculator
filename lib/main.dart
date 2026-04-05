import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
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

  bool openBracket = true;

  final List<String> buttons = [
    "C","()","%","⌫",
    "7","8","9","/",
    "4","5","6","*",
    "1","2","3","-",
    "0",".","+","="
  ];

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

      else if (value == "()") {
        if (openBracket) {
          input += "(";
        } else {
          input += ")";
        }
        openBracket = !openBracket;
      }

      else if (value == "%") {
        input += "%";
      }

      else if (value == "=") {
        if (input.isEmpty) return;
        output = calculate(input);
      }

      else {
        input += value;
      }

    });
  }

  String calculate(String expression) {

    try {

      expression = expression.replaceAll('%', '/100');

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

  Color getButtonColor(String text) {

    if (text == "C") return Colors.red;
    if (text == "=") return Colors.green;
    if ("+-*/".contains(text)) return Colors.deepPurple;

    return Colors.grey.shade800;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff0f0f1a),

      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      body: Column(

        children: [

          /// DISPLAY
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(
                    input,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    output,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                ],
              ),
            ),
          ),

          /// BUTTON GRID
          Expanded(
            flex: 5,
            child: GridView.builder(

              padding: const EdgeInsets.all(10),

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),

              itemCount: buttons.length,

              itemBuilder: (context, index) {

                String text = buttons[index];

                return GestureDetector(

                  onTap: () => buttonPressed(text),

                  child: Container(

                    decoration: BoxDecoration(
                      color: getButtonColor(text),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ),

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}