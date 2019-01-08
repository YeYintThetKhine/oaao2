// import 'package:flutter/material.dart';
// import '../../Models/records_book/record_book.dart';
// import '../../Views/records_book/imageview.dart';
// import '../../Views/records_book/profiles.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import '../../Database/database.dart';

// class DetailScreen extends StatefulWidget {
//   final Records rd;
//   DetailScreen({@required this.rd});
//   DetailScreenState createState() => DetailScreenState(record: rd);
// }

// class DetailScreenState extends State<DetailScreen> {
//   var editdoctor;
//   var edithospital;
//   var editproblem;

//   var _formKey = GlobalKey<FormState>();
//   Records record;
//   DetailScreenState({@required this.record});

//   Future<Records> fetcharecordFromDatabase() async {
//     var dbHelper = DBHelper();
//     Future<Records> records =
//         dbHelper.fetchaRecord(record.userid, record.recid);
//     return records;
//   }

//   var _fstimg;
//   var _sndimg;
//   var _trdimg;
//   var _frdimg;

//   bool _submit() {
//     if (this._formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       var dbhelper = DBHelper();
//       var rec = Records();
//       rec.date = record.date;
//       rec.userid = record.userid;
//       rec.recid = record.recid;
//       rec.doctor = editdoctor;
//       rec.hospital = edithospital;
//       rec.problem = editproblem;
//       rec.date = rec.date;
//       rec.img1 = _fstimg;
//       rec.img2 = _sndimg;
//       rec.img3 = _trdimg;
//       rec.img4 = _frdimg;

//       dbhelper.updateRecords(rec);
//       print(
//           "User updated + rec id ${rec.recid}/user id ${rec.userid}/doc ${rec.doctor}/ hos ${rec.hospital}/pro ${rec.problem}/date ${rec.date}/${rec.img1}/${rec.img2}/${rec.img3}/${rec.img4}");
//       return true;
//     } else {
//       return false;
//     }
//   }

// /*

//   void _close(){
//     noteditmode=true;
//     _doc.text=doctor;
//     _hos.text=hospital;
//     _pro.text=problem;
//   }*/
//   var noteditmode = true;

//   void initState() {
//     super.initState();
//     _fstimg = record.img1;
//     _sndimg = record.img3;
//     _trdimg = record.img2;
//     _frdimg = record.img4;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: maintheme,
//           leading: noteditmode
//               ? IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 )
//               : IconButton(
//                   icon: Icon(
//                     Icons.close,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _close();
//                     });
//                   },
//                 ),
//           actions: <Widget>[
//             noteditmode
//                 ? PopupMenuButton<String>(
//                     itemBuilder: (BuildContext context) {
//                       return SettingData.languages.map((String func) {
//                         return PopupMenuItem<String>(
//                           value: func,
//                           child: Text(func),
//                         );
//                       }).toList();
//                     },
//                     onSelected: (String func) {
//                       if (func == "Edit") {
//                         setState(() {
//                           noteditmode = false;
//                         });
//                       } else {
//                         showDialog(
//                             context: context,
//                             builder: (context) => Container(
//                                   child: AlertDialog(
//                                     content: Text(
//                                         'Do you want to delete this record?'),
//                                     actions: <Widget>[
//                                       FlatButton(
//                                         child: Text('CANCEL'),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                       ),
//                                       FlatButton(
//                                         child: Text('DELETE',
//                                             style:
//                                                 TextStyle(color: Colors.red)),
//                                         onPressed: () {
//                                           var dbHelper = DBHelper();
//                                           Navigator.pop(context);
//                                           dbHelper.deleteRecord(record.recid);
//                                           Navigator.pop(context);
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 ));
//                       }
//                     },
//                   )
//                 : IconButton(
//                     icon: Icon(
//                       Icons.check,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       if (_submit() == true) {
//                         setState(() {
//                           _showMessage('Record is successfully updated');
//                         });
//                         noteditmode = true;
//                       }
//                     },
//                   )
//           ],
//         ),
//         body: _body());
//   }

//   void _showMessage(text) {
//     showDialog(
//         context: context,
//         builder: (context) => Container(
//               child: AlertDialog(
//                 content: Text(text),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text('CLOSE'),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   )
//                 ],
//               ),
//             ));
//   }

//   void _close() {
//     noteditmode = true;
//     _fstimg = record.img1;
//     _sndimg = record.img2;
//     _trdimg = record.img3;
//     _frdimg = record.img4;
//     //_doc.text=doctor;
//     //_hos.text=hospital;
//     //_pro.text=problem;
//   }

//   Widget _body() {
//     return Container(
//         child: FutureBuilder<Records>(
//             future: fetcharecordFromDatabase(),
//             builder: (context, snapshot) => snapshot.hasData
//                 ? ListView(
//                     children: <Widget>[
//                       Column(children: <Widget>[
//                         noteditmode
//                             ? _records(snapshot.data)
//                             : _editrecord(snapshot.data),
//                         noteditmode
//                             ? Container(
//                                 child: snapshot.data.img1 == null &&
//                                         snapshot.data.img2 == null &&
//                                         snapshot.data.img3 == null &&
//                                         snapshot.data.img4 == null
//                                     ? null
//                                     : _carousel(snapshot.data))
//                             : _editimage(snapshot.data)
//                       ])
//                     ],
//                   )
//                 : Text('No Data')));
//   }

//   Widget _records(Records rec) {
//     var tileheight = 40.0;
//     return Container(
//       padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 5.0),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: tileheight,
//             child: ListTile(
//               leading: SizedBox(
//                 width: 60.0,
//                 child: Text('Created Date',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               title: Text(rec.date),
//             ),
//           ),
//           SizedBox(
//             height: tileheight,
//             child: ListTile(
//               leading: SizedBox(
//                 width: 60.0,
//                 child: Text('Doctor',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               title: Text(rec.doctor),
//             ),
//           ),
//           SizedBox(
//             height: tileheight,
//             child: ListTile(
//               leading: SizedBox(
//                 width: 60.0,
//                 child: Text('Hospital',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               title: Text(rec.hospital),
//             ),
//           ),
//           SizedBox(
//             height: tileheight,
//             child: ListTile(
//               leading: SizedBox(
//                 width: 60.0,
//                 child: Text('Problem',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               title: Text(rec.problem),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _editrecord(Records rec) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 5.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.only(left: 16.0, top: 10.0),
//               child: Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 60.0,
//                     child: Text('Created Date',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   Padding(
//                     child: Text(rec.date, style: TextStyle(fontSize: 16.0)),
//                     padding: EdgeInsets.only(left: 14.0),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               height: 56.0,
//               child: ListTile(
//                   leading: Container(
//                     width: 60.0,
//                     child: Text('Doctor',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   title: TextFormField(
//                     initialValue: rec.doctor,
//                     validator: (val) =>
//                         val.length == 0 ? 'Doctor name is required' : null,
//                     onSaved: (val) => this.editdoctor = val,
//                   )),
//             ),
//             Container(
//               height: 56.0,
//               child: ListTile(
//                   leading: Container(
//                     width: 60.0,
//                     child: Text('Hospital',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   title: TextFormField(
//                     initialValue: rec.hospital,
//                     validator: (val) =>
//                         val.length == 0 ? 'Hospital name is required' : null,
//                     onSaved: (val) => this.edithospital = val,
//                   )),
//             ),
//             Container(
//               height: 56.0,
//               child: ListTile(
//                   leading: Container(
//                     width: 60.0,
//                     child: Text('Problem',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   title: TextFormField(
//                     initialValue: rec.problem,
//                     validator: (val) =>
//                         val.length == 0 ? 'Problem name is required' : null,
//                     onSaved: (val) => this.editproblem = val,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _carousel(Records rec) {
//     List<Widget> imgitems = List<Widget>();
//     imgitems.clear();
//     if (rec.img1 != null) {
//       imgitems.add(Container(
//           width: 300.0,
//           height: 300.0,
//           child: Card(
//               elevation: 5.0,
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ImageView(
//                                 img: rec.img1,
//                               )));
//                 },
//                 child: Image.memory(
//                   rec.img1,
//                   fit: BoxFit.cover,
//                 ),
//               ))));
//     }
//     if (rec.img2 != null) {
//       imgitems.add(Container(
//           width: 300.0,
//           height: 300.0,
//           child: Card(
//               elevation: 5.0,
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ImageView(
//                                 img: rec.img2,
//                               )));
//                 },
//                 child: Image.memory(
//                   rec.img2,
//                   fit: BoxFit.cover,
//                 ),
//               ))));
//     }
//     if (rec.img3 != null) {
//       imgitems.add(Container(
//           width: 300.0,
//           height: 300.0,
//           child: Card(
//               elevation: 5.0,
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ImageView(
//                                 img: rec.img3,
//                               )));
//                 },
//                 child: Image.memory(
//                   rec.img3,
//                   fit: BoxFit.cover,
//                 ),
//               ))));
//     }
//     if (rec.img4 != null) {
//       imgitems.add(Container(
//           width: 300.0,
//           height: 300.0,
//           child: Card(
//               elevation: 5.0,
//               child: MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ImageView(
//                                 img: rec.img4,
//                               )));
//                 },
//                 child: Image.memory(
//                   rec.img4,
//                   fit: BoxFit.cover,
//                 ),
//               ))));
//     }
//     return Padding(
//       padding: EdgeInsets.only(top: 20.0),
//       child: CarouselSlider(
//           initialPage: 0,
//           items: imgitems.map((i) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Container(
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.symmetric(horizontal: 5.0),
//                     child: Container(child: (i)));
//               },
//             );
//           }).toList(),
//           height: 300.0,
//           autoPlay: false),
//     );
//   }

//   Widget _editimage(Records rec) {
//     var _imgheight = MediaQuery.of(context).size.height / 4;
//     return Container(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                       child: Card(
//                           child: Container(
//                     height: MediaQuery.of(context).size.height / 4,
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: GridTile(
//                         child: Container(
//                           child: _fstimg != null
//                               ? Image.memory(
//                                   _fstimg,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.asset('images/imgg.png'),
//                         ),
//                         header: Container(
//                           alignment: FractionalOffset.topRight,
//                           child: IconButton(
//                             icon: Icon(Icons.cancel),
//                             onPressed: () {
//                               setState(() {
//                                 _fstimg = null;
//                               });
//                             },
//                           ),
//                         ),
//                         footer: Container(
//                           child: Stack(
//                             children: <Widget>[
//                               Container(
//                                 alignment: Alignment.bottomLeft,
//                                 child: IconButton(
//                                   icon: Icon(Icons.camera_alt),
//                                   onPressed: _camerapicker1,
//                                 ),
//                               ),
//                               Container(
//                                 alignment: Alignment.bottomRight,
//                                 child: IconButton(
//                                   icon: Icon(Icons.image),
//                                   onPressed: _gallerypicker1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                   ))),
//                   Expanded(
//                       child: Card(
//                           child: Container(
//                     height: MediaQuery.of(context).size.height / 4,
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: GridTile(
//                       child: Container(
//                         height: _imgheight,
//                         child: _sndimg != null
//                             ? Image.memory(
//                                 _sndimg,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset('images/imgg.png'),
//                       ),
//                       header: Container(
//                         alignment: FractionalOffset.topRight,
//                         child: IconButton(
//                           icon: Icon(Icons.cancel),
//                           onPressed: () {
//                             setState(() {
//                               _sndimg = null;
//                             });
//                           },
//                         ),
//                       ),
//                       footer: Container(
//                         child: Stack(
//                           children: <Widget>[
//                             Container(
//                               alignment: Alignment.bottomLeft,
//                               child: IconButton(
//                                 icon: Icon(Icons.camera_alt),
//                                 onPressed: _camerapicker2,
//                               ),
//                             ),
//                             Container(
//                               alignment: Alignment.bottomRight,
//                               child: IconButton(
//                                 icon: Icon(Icons.image),
//                                 onPressed: _gallerypicker2,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ))),
//                 ],
//               ),
//             ),
//             Container(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                       child: Card(
//                           child: Container(
//                               height: MediaQuery.of(context).size.height / 4,
//                               width: MediaQuery.of(context).size.width / 2,
//                               child: GridTile(
//                                 child: Container(
//                                   height: _imgheight,
//                                   child: _trdimg != null
//                                       ? Image.memory(
//                                           _trdimg,
//                                           fit: BoxFit.cover,
//                                         )
//                                       : Image.asset('images/imgg.png'),
//                                 ),
//                                 header: Container(
//                                   alignment: FractionalOffset.topRight,
//                                   child: IconButton(
//                                     icon: Icon(Icons.cancel),
//                                     onPressed: () {
//                                       setState(() {
//                                         _trdimg = null;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 footer: Container(
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Container(
//                                         alignment: Alignment.bottomLeft,
//                                         child: IconButton(
//                                           icon: Icon(Icons.camera_alt),
//                                           onPressed: _camerapicker3,
//                                         ),
//                                       ),
//                                       Container(
//                                         alignment: Alignment.bottomRight,
//                                         child: IconButton(
//                                           icon: Icon(Icons.image),
//                                           onPressed: _gallerypicker3,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )))),
//                   Expanded(
//                       child: Card(
//                           child: Container(
//                               height: MediaQuery.of(context).size.height / 4,
//                               width: MediaQuery.of(context).size.width / 2,
//                               child: GridTile(
//                                 child: Container(
//                                   height: _imgheight,
//                                   child: _frdimg != null
//                                       ? Image.memory(
//                                           _frdimg,
//                                           fit: BoxFit.cover,
//                                         )
//                                       : Image.asset('images/imgg.png'),
//                                 ),
//                                 header: Container(
//                                   alignment: FractionalOffset.topRight,
//                                   child: IconButton(
//                                     icon: Icon(Icons.cancel),
//                                     onPressed: () {
//                                       setState(() {
//                                         _frdimg = null;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 footer: Container(
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Container(
//                                         alignment: Alignment.bottomLeft,
//                                         child: IconButton(
//                                           icon: Icon(Icons.camera_alt),
//                                           onPressed: _camerapicker4,
//                                         ),
//                                       ),
//                                       Container(
//                                         alignment: Alignment.bottomRight,
//                                         child: IconButton(
//                                           icon: Icon(Icons.image),
//                                           onPressed: _gallerypicker4,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )))),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }

//   Future _gallerypicker1() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (f != null) {
//         print(f.path);
//         _fstimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _camerapicker1() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (f != null) {
//         _fstimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _gallerypicker2() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (f != null) {
//         print(f.path);
//         _sndimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _camerapicker2() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (f != null) {
//         _sndimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _gallerypicker3() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (f != null) {
//         print(f.path);
//         _trdimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _camerapicker3() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (f != null) {
//         _trdimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _gallerypicker4() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (f != null) {
//         print(f.path);
//         _frdimg = f.readAsBytesSync();
//       }
//     });
//   }

//   Future _camerapicker4() async {
//     File f = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (f != null) {
//         _frdimg = f.readAsBytesSync();
//       }
//     });
//   }
// }

import 'package:flutter/material.dart';
import '../../Models/records_book/record_book.dart';
import '../../Views/records_book/imageview.dart';
import '../../Database/database.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DetailScreen extends StatefulWidget {
  final Records rd;
  DetailScreen({@required this.rd});
  DetailScreenState createState() => DetailScreenState(record: rd);
}

class DetailScreenState extends State<DetailScreen> {
  Records record;
  DetailScreenState({@required this.record});

  Future<List<ImageData>> fetchimagesFromDatabase() async {
    var dbHelper = DBHelper();
    Future<List<ImageData>> records =
        dbHelper.fetchImageDataList(userid: record.userid, recid: record.recid);
    return records;
  }

  Widget _recordlist() {
    return FutureBuilder<List<ImageData>>(
      future: fetchimagesFromDatabase(),
      builder: (context, snapshot) => (snapshot.hasData &&
              snapshot.data.length != 0)
          // ?GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3
          //   ),
          //   itemCount:snapshot.data.length,
          //   itemBuilder: (context,index){
          //     Image.memory(snapshot.data[index].imgData);
          //   },
          // )
          ? Container(
              child: Swiper(
                itemHeight: 300.0,
                itemWidth: 300.0,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    Image.memory(snapshot.data[index].imgData),
                loop: false,
                pagination: SwiperPagination(builder: SwiperPagination.dots),
                control: SwiperControl(),
                viewportFraction: 0.86,
                scale: 0.5,
                onTap: (na) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowImages(
                            imgdata: snapshot.data[na].imgData,
                          )));
                },
              ),
              color: Colors.lightGreen[300],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    child: Image.asset('images/test.png'),
                  ),
                )
              ],
            ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Record Details', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                child: ListTile(
                  leading: SizedBox(
                    width: 60.0,
                    child: Text('Created Date',
                        style: TextStyle(
                            color: Color(0xFF72BB53),
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(record.date),
                ),
              ),
              SizedBox(
                height: 50.0,
                child: ListTile(
                  leading: SizedBox(
                    width: 60.0,
                    child: Text('Doctor',
                        style: TextStyle(
                            color: Color(0xFF72BB53),
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(record.doctor),
                ),
              ),
              SizedBox(
                height: 50.0,
                child: ListTile(
                  leading: SizedBox(
                    width: 60.0,
                    child: Text('Hospital',
                        style: TextStyle(
                            color: Color(0xFF72BB53),
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(record.hospital),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Container(
                  child: ListTile(
                    leading: SizedBox(
                      width: 60.0,
                      child: Text('Problem',
                          style: TextStyle(
                              color: Color(0xFF72BB53),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(record.problem),
                  ),
                ),
              ),
              Container(
                height: 300,
                child: _recordlist(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
