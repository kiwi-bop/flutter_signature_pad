import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;

class SignatureController {
  final CustomPainter? backgroundPainter;
  List<Offset?> points = <Offset?>[];
  void Function()? _onChange;
  _SignaturePainter? _painter;
  late Size _lastSize;

  SignatureController({this.backgroundPainter});

  bool get hasPoints => points.isNotEmpty;

  Future<ui.Image> getData() {
    var recorder = ui.PictureRecorder();
    var origin = const Offset(0.0, 0.0);
    var paintBounds = Rect.fromPoints(
        _lastSize.topLeft(origin), _lastSize.bottomRight(origin));
    var canvas = Canvas(recorder, paintBounds);
    if (backgroundPainter != null) {
      backgroundPainter!.paint(canvas, _lastSize);
    }
    _painter!.paint(canvas, _lastSize);
    var picture = recorder.endRecording();
    return picture.toImage(_lastSize.width.round(), _lastSize.height.round());
  }

  void clear() {
    points = [];
    if (_onChange != null) {
      _onChange!();
    }
  }
}

class Signature extends StatefulWidget {
  final SignatureController controller;
  final Color color;
  final double strokeWidth;
  final Function? onSign;

  const Signature({
    required this.controller,
    this.color = Colors.black,
    this.strokeWidth = 5.0,
    this.onSign,
    Key? key,
  }) : super(key: key);

  @override
  State<Signature> createState() => SignatureState();

  static SignatureState? of(BuildContext context) {
    return context.findAncestorStateOfType<SignatureState>();
  }
}

class _SignaturePainter extends CustomPainter {
  final double strokeWidth;
  final List<Offset?> points;
  final Color strokeColor;
  late Paint _linePaint;

  _SignaturePainter(
      {required this.points,
      required this.strokeColor,
      required this.strokeWidth}) {
    _linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, _linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) =>
      oldDelegate.points != points;
}

class SignatureState extends State<Signature> {
  SignatureState();

  @override
  void initState() {
    super.initState();
    widget.controller._onChange = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
    widget.controller._painter = _SignaturePainter(
        points: widget.controller.points,
        strokeColor: widget.color,
        strokeWidth: widget.strokeWidth);
    return ClipRect(
      child: CustomPaint(
        painter: widget.controller.backgroundPainter,
        foregroundPainter: widget.controller._painter,
        child: GestureDetector(
          onVerticalDragStart: _onDragStart,
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          onPanStart: _onDragStart,
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    setState(() {
      widget.controller.points = List.from(widget.controller.points)
        ..add(localPosition)
        ..add(localPosition);
    });
  }

  void _onTapUp(TapUpDetails details) {
    RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    setState(() {
      widget.controller.points = List.from(widget.controller.points)
        ..add(localPosition);
      if (widget.onSign != null) {
        widget.onSign!();
      }
    });
    widget.controller.points.add(null);
  }

  void _onDragStart(DragStartDetails details) {
    RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    setState(() {
      widget.controller.points = List.from(widget.controller.points)
        ..add(localPosition)
        ..add(localPosition);
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);

    setState(() {
      widget.controller.points = List.from(widget.controller.points)
        ..add(localPosition);
      if (widget.onSign != null) {
        widget.onSign!();
      }
    });
  }

  void _onDragEnd(DragEndDetails details) => widget.controller.points.add(null);

  afterFirstLayout(BuildContext context) {
    widget.controller._lastSize = context.size!;
  }
}
