import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: MyTextField()),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      controller: controller,
      specialTextSpanBuilder: EmailSpanBuilder(controller, context),
    );
  }
}

class EmailSpanBuilder extends SpecialTextSpanBuilder {
  EmailSpanBuilder(this.controller, this.context);

  final TextEditingController controller;
  final BuildContext context;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    if (!flag.startsWith(' ') && !flag.startsWith('@')) {
      return EmailText(textStyle!, onTap,
          start: index,
          context: context,
          controller: controller,
          startFlag: flag);
    }

    return null;
  }
}

class EmailText extends SpecialText {
  EmailText(TextStyle textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start, this.controller, this.context, required String startFlag})
      : super(startFlag, ' ', textStyle, onTap: onTap);

  final TextEditingController? controller;
  final int? start;
  final BuildContext? context;

  @override
  bool isEnd(String value) {
    final index = value.indexOf('@');
    final index1 = value.indexOf('.');

    return index >= 0 && index1 >= 0 && (index1 > index + 1);
  }

  @override
  InlineSpan finishText() {
    final String text = toString();

    return ExtendedWidgetSpan(
      actualText: text,
      start: start!,
      alignment: ui.PlaceholderAlignment.middle,
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(right: 5, top: 2, bottom: 2),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    text.trim(),
                    style: textStyle?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.close,
                      size: 15.0,
                    ),
                    onTap: () {
                      controller!.value = controller!.value.copyWith(
                          text: controller!.text
                              .replaceRange(start!, start! + text.length, ''),
                          selection: TextSelection.fromPosition(
                              TextPosition(offset: start!)));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          showDialog<void>(
            context: context!,
            barrierDismissible: true,
            builder: (BuildContext c) {
              final TextEditingController textEditingController =
                  TextEditingController()..text = text.trim();
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Material(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          suffixIcon: TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          controller!.value = controller!.value.copyWith(
                            text: controller!.text.replaceRange(
                                start!,
                                start! + text.length,
                                '${textEditingController.text} '),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset: start! +
                                      '$textEditingController.text} '.length),
                            ),
                          );
                          Navigator.pop(context!);
                        },
                      )),
                    ),
                  )),
                  Expanded(
                    child: Container(),
                  )
                ],
              );
            },
          );
        },
      ),
      deleteAll: true,
    );
  }
}
