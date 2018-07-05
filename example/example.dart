import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    var sign = Signature(
      color: Colors.red,
      strokeWidth: 5.0,
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
              LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List())),
              Padding(
                padding: EdgeInsets.all(25.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  MaterialButton(
                      color: Colors.green,
                      onPressed: () async {
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        var data = await sign
                            .getData()
                            .toByteData(format: ui.ImageByteFormat.png);
                        setState(() {
                          _img = data;
                        });
                        debugPrint("onPressed " +
                            base64.encode(data.buffer.asUint8List()));
                      },
                      child: Text("Save")),
                  MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        sign.clear();
                        debugPrint("cleared");
                      },
                      child: Text("Clear")),
                ]),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
