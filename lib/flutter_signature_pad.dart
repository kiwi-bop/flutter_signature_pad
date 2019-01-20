import 'dart:ui' as ui;

import 'package:flutter/material.dart';

final _signatureKey = GlobalKey<SignatureState>();

class Signature extends StatefulWidget {
  final Color color;
  final double strokeWidth;
  final CustomPainter backgroundPainter;
  final Function onSign;
  final GlobalKey<SignatureState> _key;

  Signature({this.color = Colors.black, this.strokeWidth = 5.0, this.backgroundPainter, this.onSign, GlobalKey key}) : _key = key ?? _signatureKey, super(key: key ?? _signatureKey);

  SignatureState createState() => SignatureState();

  ui.Image getData() {
    return _key.currentState.getData();
  }

  clear() {
    return _key.currentState.clear();
  }
}

class _SignaturePainter extends CustomPainter {
  Size _lastSize;
  final double strokeWidth;
  final List<Offset> points;
  final Color strokeColor;
  Paint _linePaint;

  _SignaturePainter({@required this.points, @required this.strokeColor, @required this.strokeWidth}) {
    _linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    _lastSize = size;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) canvas.drawLine(points[i], points[i + 1], _linePaint);
    }
  }

  bool shouldRepaint(_SignaturePainter other) => other.points != points;
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  _SignaturePainter _painter;
  Size _lastSize;

  SignatureState();

  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
    _painter = _SignaturePainter(points: _points, strokeColor: widget.color, strokeWidth: widget.strokeWidth);
    return ClipRect(
      child: CustomPaint(
        painter: widget.backgroundPainter,
        foregroundPainter: _painter,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition = referenceBox.globalToLocal(details.globalPosition);

            setState(() {
              _points = List.from(_points)..add(localPosition);
              if(widget.onSign != null) {
                widget.onSign();
              }
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
        ),
      ),
    );
  }

  ui.Image getData() {
    var recorder = ui.PictureRecorder();
    var origin = Offset(0.0, 0.0);
    var paintBounds = Rect.fromPoints(_lastSize.topLeft(origin), _lastSize.bottomRight(origin));
    var canvas = Canvas(recorder, paintBounds);
    widget.backgroundPainter.paint(canvas, _lastSize);
    _painter.paint(canvas, _lastSize);
    var picture = recorder.endRecording();
    return picture.toImage(_lastSize.width.round(), _lastSize.height.round());
  }

  void clear() {
    setState(() {
      _points = [];
    });
  }

  afterFirstLayout(BuildContext context) {
    _lastSize = context.size;
  }
}
