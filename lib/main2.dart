import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    // const text =
    //     'When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are \(x = {-b \pm \sqrt{b^2-4ac} \over 2a}\).';
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: TextField(
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
              ),
            ),
            Text(value),
            TeXView(
              child: TeXViewDocument(
                value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
