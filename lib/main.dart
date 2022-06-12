import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equation Input Test',
      home: Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: EquationTextField(),
          )),
    );
  }
}

class EquationTextField extends StatefulWidget {
  const EquationTextField({Key? key}) : super(key: key);

  @override
  State<EquationTextField> createState() => _EquationTextFieldState();
}

class _EquationTextFieldState extends State<EquationTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      controller: controller,
      specialTextSpanBuilder: EquationSpanBuilder(context, controller),
    );
  }
}

class EquationSpanBuilder extends SpecialTextSpanBuilder {
  EquationSpanBuilder(this.context, this.controller);

  final BuildContext context;
  final TextEditingController controller;

  @override
  SpecialText? createSpecialText(
    String flag, {
    required int index,
    void Function(dynamic)? onTap,
    TextStyle? textStyle,
  }) {
    if (flag != '' && isStart(flag, EquationText.firstFlag)) {
      return EquationText(textStyle ?? const TextStyle());
    }

    return null;
  }
}

class EquationText extends SpecialText {
  EquationText(TextStyle textStyle)
      : super(
          EquationText.firstFlag,
          EquationText.lastFlag,
          textStyle,
        );

  static const firstFlag = r'\(';
  static const lastFlag = r'\)';

  @override
  InlineSpan finishText() {
    return ExtendedWidgetSpan(
      actualText: 'Hello',
      child: Text(
        toString(),
        style: const TextStyle(color: Colors.orange),
      ),
    );
  }
}
