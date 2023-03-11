# Flutter signature pad widget

Flutter widget to allow users to sign with finger and export the result as image.

## Getting Started with the widget
This is a very simple widget that allow drawing by finger on a widget and be able to get the image back.

For very basic usage, please check the example file [here](https://github.com/kiwi-bop/flutter_signature_pad/blob/master/example/lib/main.dart)

```dart
Widget build(BuildContext context) {
  // Controller is used 
  final controller = SignatureController(
    backgroundPainter: null, // Additional custom painter to draw stuff like watermark
  );
  return Column(children: [
    Signature(
        controller: controller
        color: Colors.black, // Color of the drawing path
        strokeWidth: 5.0, // width of the drawing path
        onSign: null, // Callback called on user pan drawing
        ),
    ElevatedButton(
        onPressed: () => controller.getData().then((image) => /* process image */),
        child: Text("Save")),
    ElevatedButton(
        onPressed: () => controller.clear(),
        child: Text("Clear"))
  ]);
}
```

## API 

The controller exposes the following methods:

`clear`: allow you to clear the area to start again

`getData`: allow you to retrieve the image

`hasPoints`: to know if user has sign or not

`points`: to retrieve the list of points of the signature
