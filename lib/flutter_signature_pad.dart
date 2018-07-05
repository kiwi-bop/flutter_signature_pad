import 'dart:ui' as ui;

import 'package:flutter/material.dart';

final signatureKey = GlobalKey<SignatureState>();

class Signature extends StatefulWidget {
  final Color color;
  final double strokeWidth;

  Signature({this.color = Colors.black, this.strokeWidth = 5.0})
      : super(key: signatureKey);

  SignatureState createState() =>
      SignatureState(color: color, strokeWidth: strokeWidth);

  ui.Image getData() {
    return signatureKey.currentState.getData();
  }

  clear() {
    return signatureKey.currentState.clear();
  }
}

class SignaturePainter extends CustomPainter {
  Size _lastSize;
  final double strokeWidth;
  final List<Offset> points;
  final Color strokeColor;

  SignaturePainter(
      {@required this.points,
      @required this.strokeColor,
      @required this.strokeWidth});

  void paint(Canvas canvas, Size size) {
    _lastSize = size;
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  ui.Image getData() {
    var recorder = ui.PictureRecorder();
    var origin = Offset(0.0, 0.0);
    var paintBounds = Rect.fromPoints(
        _lastSize.topLeft(origin), _lastSize.bottomRight(origin));
    var canvas = Canvas(recorder, paintBounds);
    paint(canvas, _lastSize);
    var picture = recorder.endRecording();
    return picture.toImage(_lastSize.width.round(), _lastSize.height.round());
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  SignaturePainter _painter;

  final Color color;
  final double strokeWidth;

  SignatureState({@required this.color, @required this.strokeWidth});

  Widget build(BuildContext context) {
    _painter = SignaturePainter(
        points: _points, strokeColor: color, strokeWidth: strokeWidth);
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _painter),
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);

            setState(() {
              _points = List.from(_points)..add(localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
        ),
      ],
    );
  }

  ui.Image getData() {
    return _painter.getData();
  }

  void clear() {
    setState(() {
      _points = [];
    });
  }
}
