import 'package:flutter/material.dart';
import 'dart:async';
import 'package:oaao/Views/records_book/profiles.dart';
import 'package:oaao/Database/database.dart';
import 'package:oaao/Views/records_book/meddetail.dart';
import '../../Models/records_book/record_book.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';
import '../records_book/image_preview.dart';
import 'package:random_string/random_string.dart' as random;

class MedRec extends StatefulWidget {
  final int id;
  MedRec({@required this.id});
  MedRecState createState() => MedRecState(userid: id);
}

int uid;

Future<List<Records>> fetchrecordsFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Records>> records = dbHelper.fetchRecordsList(uid);
  return records;
}

const timeout = const Duration(milliseconds: 100);
const ms = const Duration(milliseconds: 1);

TextEditingController doc = TextEditingController();
TextEditingController hos = TextEditingController();
TextEditingController pro = TextEditingController();
var date = DateTime.now();
String tday = date.day.toString();
String tmonth = date.month.toString();
String tyear = date.year.toString();
var _visible = true;
List<Asset> images = List<Asset>();

class MedRecState extends State<MedRec> with SingleTickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  final int userid;
  MedRecState({@required this.userid});

  String recid;
  String doctor;
  String hospital;
  String problem;

  bool _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      var dbhelper = DBHelper();
      var rec = Records();
      rec.userid = userid;
      rec.recid = recid;
      rec.doctor = doctor;
      rec.hospital = hospital;
      rec.problem = problem;
      rec.date = tddate;

      dbhelper.addRecord(rec);
      print(
          "User added + rec id ${rec.recid}/user id ${rec.userid}/doc ${rec.doctor}/ hos ${rec.hospital}/pro ${rec.problem}/date ${rec.date}");
      for (Asset asset in images) {
        var recImg = ImageData();
        recImg.userid = userid;
        recImg.recid = recid;
        recImg.imgData = asset.imageData.buffer.asUint8List();
        dbhelper.addImages(recImg);
      }
      setState(() {
        recid = random.randomAlphaNumeric(15);
      });
      return true;
    } else {
      return false;
    }
  }

  Widget _recordList() {
    return FutureBuilder<List<Records>>(
      future: fetchrecordsFromDatabase(),
      builder: (context, snapshot) => (snapshot.hasData &&
              snapshot.data.length != 0)
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
                    child: Card(
                        elevation: 7.0,
                        child: ListTile(
                          title: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Date : ${snapshot.data[index].date}',
                                    style: TextStyle(color: Colors.green)),
                                Text('Doctor : ${snapshot.data[index].doctor}',
                                    style: TextStyle(color: Colors.green)),
                                Text(
                                    'Hospital : ${snapshot.data[index].hospital}',
                                    style: TextStyle(color: Colors.green)),
                                Text(
                                    'Problem : ${snapshot.data[index].problem}',
                                    style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                          /*trailing: IconButton(
              icon: Icon(Icons.)
            ),*/
                          subtitle: Text(snapshot.data.length.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          rd: snapshot.data[index],
                                        )));
                          },
                        )),
                  ),
            )
          : Column(
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

  final FocusNode hospitalNode = FocusNode();
  final FocusNode descNode = FocusNode();
  static const _PANEL_HEADER_HEIGHT = 26.0;
  AnimationController _controller;
  ScrollController scrlcont = new ScrollController();

  String tddate = tday + '/' + tmonth + '/' + tyear;
  var buttonwidth;
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 0.0, vsync: this);
    setState(() {
      uid = userid;
      recid = random.randomAlphaNumeric(15);
    });
  }

  double gridheight = 20.0;
  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (resultList.length == 0) {
        gridheight = 20;
      } else if (resultList.length < 4) {
        gridheight = 150.0;
      } else {
        gridheight = 300.0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  bool add = true;
  Widget build(BuildContext context) {
    buttonwidth = MediaQuery.of(context).size.width / 1.1;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: maintheme,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text(
          "MEDICAL RECORDS",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: _visible
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              tooltip: 'Create Medical Record',
              child: Icon(add ? Icons.add : Icons.close),
              onPressed: () {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                setState(() {
                  if (add == true) {
                    add = false;
                  } else {
                    add = true;
                  }
                  images = List<Asset>();
                  gridheight = 20.0;
                });
              },
            )
          : null,
      body: new LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  void _reset() {
    doc.clear();
    hos.clear();
    pro.clear();
    scrlcont.animateTo(0.0,
        duration: const Duration(milliseconds: 10), curve: Curves.easeOut);
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Widget buildGridView() {
    return Container(
      //    child:GridView.count(
      //   crossAxisCount: 3,
      //   children: List.generate(images.length, (index) {
      //     // return InkWell(
      //     //   child:Container(
      //     //     child:AssetView(index, images[index]),
      //     //   ),
      //     //   onTap: (){
      //     //     Navigator.of(context).push(
      //     //             MaterialPageRoute(
      //     //               builder: (context)=>ShowImages(i:index,imgdata: images[index].imageData.buffer.asUint8List(),
      //     //               )
      //     //             )
      //     //           );
      //     //   },
      //     // );
      //     return Container(
      //         child:AssetView(index, images[index]),
      //       );
      //   }),
      // )
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: images.length,
        itemBuilder: (context, index) => Container(
              child: AssetView(index, images[index]),
            ),
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    return new Container(
      color: maintheme,
      child: new Stack(
        children: <Widget>[
          Container(child: _recordList()),
          PositionedTransition(
            rect: animation,
            child: new Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0)),
              elevation: 12.0,
              child: ListView(
                controller: scrlcont,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 6.0, right: 12.0, left: 12.0),
                          alignment: add
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(tddate,
                              style: TextStyle(
                                  color: Color(0xFF1487de),
                                  fontWeight: FontWeight.bold)),
                        ),
                        Form(
                          key: formKey,
                          child: Container(
                            padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Color(0xFF1487de)),
                                      counterText: 'Doctor name',
                                      border: OutlineInputBorder(),
                                      labelText: 'DOCTOR',
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? "Doctor name is required"
                                        : null,
                                    onSaved: (val) => this.doctor = val,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(hospitalNode);
                                    },
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Color(0xFF1487de)),
                                        counterText: 'Hospital name',
                                        border: OutlineInputBorder(),
                                        labelText: 'HOSPITAL'),
                                    focusNode: hospitalNode,
                                    onEditingComplete: () =>
                                        FocusScope.of(context)
                                            .requestFocus(descNode),
                                    validator: (val) => val.isEmpty
                                        ? "Hospital name is required"
                                        : null,
                                    onSaved: (val) => this.hospital = val,
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Color(0xFF1487de)),
                                        counterText: 'Record description',
                                        border: OutlineInputBorder(),
                                        labelText: 'PROBLEM'),
                                    focusNode: descNode,
                                    validator: (val) => val.isEmpty
                                        ? "Problem name is required"
                                        : null,
                                    onSaved: (val) => this.problem = val,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            width: buttonwidth / 2,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              color: Color(0xFF71c2ff),
                              child: Text(
                                'Choose Images',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              onPressed: loadAssets,
                            )),
                        Container(
                          height: gridheight,
                          padding:
                              EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                          child: buildGridView(),
                        ),
                        Container(
                            width: buttonwidth,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              color: Color(0xFF6dff6e),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              onPressed: () {
                                // print(images[0].imageData.toString());
                                print(recid);
                                _submit();
                                print(recid);
                              },
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
