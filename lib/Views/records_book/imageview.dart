import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:typed_data' show Uint8List;

class ImageView extends StatefulWidget {
  final Uint8List img;
  ImageView({@required this.img});
  _ImageViewState createState() => _ImageViewState(img: img);
}

class _ImageViewState extends State<ImageView> {
  Uint8List img;
  _ImageViewState({@required this.img});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body:PhotoView(
        backgroundColor: Colors.white,
        loadingChild: CircularProgressIndicator(),   
        minScale: 0.5,
        maxScale: 4.0,     
              imageProvider: MemoryImage(img)
            )
    );
  }
}