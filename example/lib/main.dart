import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final key = Key('signature');

  @override
  Widget build(BuildContext context) {
    var sign = Signature(
      color: color,
      strokeWidth: strokeWidth,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: sign),
              LimitedBox(maxHeight: 200.0, child: Image.memory(_img.buffer.asUint8List())),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            color: Colors.green,
                            onPressed: () async {
                              //retrieve image data, do whatever you want with it (send to server, save locally...)

                              var data = await sign.getData().toByteData(format: ui.ImageByteFormat.png);
                              setState(() {
                                _img = data;
                              });
                              debugPrint("onPressed " + base64.encode(data.buffer.asUint8List()));
                            },
                            child: Text("Save")),
                        MaterialButton(
                            color: Colors.grey,
                            onPressed: () {
                              sign.clear();
                              debugPrint("cleared");
                            },
                            child: Text("Clear")),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                            onPressed: () {
                              setState(() {
                                color = color == Colors.green ? Colors.red : Colors.green;
                              });
                              debugPrint("change color");
                            },
                            child: Text("Change color")),
                        MaterialButton(
                            onPressed: () {
                              setState(() {
                                int min = 1;
                                int max = 10;
                                int selection = min + (Random().nextInt(max - min));
                                strokeWidth = selection.roundToDouble();
                                debugPrint("change stroke width to $selection");
                              });
                            },
                            child: Text("Change stroke width")),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
