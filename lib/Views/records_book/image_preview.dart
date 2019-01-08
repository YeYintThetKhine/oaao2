import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'imageview.dart';
import 'medrecords.dart';
import 'dart:io';

class AssetView extends StatefulWidget {
  final int _index;
  final Asset _asset;

  AssetView(this._index, this._asset);

  @override
  State<StatefulWidget> createState() => AssetState(this._index, this._asset);
}

class AssetState extends State<AssetView> {
  
  int _index = 0;
  Asset _asset;
  AssetState(this._index, this._asset);
  File f;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }
  

  void _loadImage() async {
    await this._asset.requestOriginal(quality: 100);
    setState(() {});
  }
  void dispose() {
    super.dispose();
    _asset.releaseOriginal();
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.imageData) {
      // return Image.memory(
      //   this._asset.imageData.buffer.asUint8List(),
      //   fit: BoxFit.cover,
      //   gaplessPlayback: true,
      // );
      return InkWell(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(this._asset.imageData.buffer.asUint8List()),
              fit: BoxFit.cover,
            ),
          ),
          ),
      onTap: (){
            Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context)=>ShowImages(i:_index,imgdata: images[_index].imageData.buffer.asUint8List(),
                      )
                    )
                  );
          },
      );
    }

    // return RefreshProgressIndicator(
    // );
     return Container(width: 0.0, height: 0.0);
  }
}
