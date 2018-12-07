# Flutter signature pad widget

Flutter widget to allow users to sign with finger and export the result as image.

## Getting Started with Flutter

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).

## Getting Started with the widget
This is a very simple widget that allow drawing by finger on a widget and be able to get the image back.

For very basic usage, please check the example file [here](https://github.com/kiwi-bop/flutter_signature_pad/blob/master/example/lib/main.dart)

## API

The constructor of the widget allow you to change the `color` (default to black), the `strokeWidth` (default to 5.0) and a `backgroundPainter` if you want to add some kind of watermark

`clear`: allow you to clear the area to start again

`getData`: allow you to retrieve the image
