import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignatureWidget extends StatelessWidget {
  SignatureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SignatureController(
      backgroundPainter:
          null, // Additional custom painter to draw stuff like watermark
    );
    return Column(children: [
      Signature(
          color: Colors.black, // Color of the drawing path
          strokeWidth: 5.0, // with
          onSign: null, // Callback called on user pan drawing
          controller: controller),
      ElevatedButton(
          onPressed: () => controller.getData().then((image) {
                // Convert image as you wish
              }),
          child: Text("Save"))
    ]);
  }
}
