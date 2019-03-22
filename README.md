# Flutter signature pad widget

Flutter widget to allow users to sign with finger and export the result as image.

## Getting Started with the widget
This is a very simple widget that allow drawing by finger on a widget and be able to get the image back.

For very basic usage, please check the example file [here](https://github.com/kiwi-bop/flutter_signature_pad/blob/master/example/lib/main.dart)

```dart
Signature(
  color: Colors.black,// Color of the drawing path
  strokeWidth: 5.0, // with 
  backgroundPainter: null, // Additional custom painter to draw stuff like watermark 
  onSign: null, // Callback called on user pan drawing
  key: null, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
);
```

## API 

Once you retrieved the SignatureState from your GlobalKey, you'll have access to this API:

`clear`: allow you to clear the area to start again

`getData`: allow you to retrieve the image

`hasPoints`: to know if user has sign or not

`points`: to retrieve the list of points of the signature
