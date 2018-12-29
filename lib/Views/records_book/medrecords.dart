import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import '../../Views/records_book/profiles.dart';
import 'dart:typed_data' show Uint8List;
import '../../Database/database.dart';
import '../../Models/records_book/record_book.dart';
import '../../Views/records_book/meddetail.dart';

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

class MedRecState extends State<MedRec> with SingleTickerProviderStateMixin {
  final int userid;
  MedRecState({@required this.userid});

  String doctor;
  String hospital;
  String problem;
  Uint8List _fstimg;
  Uint8List _sndimg;
  Uint8List _trdimg;
  Uint8List _frdimg;

  var formKey = GlobalKey<FormState>();
  final FocusNode hospitalNode = FocusNode();
  final FocusNode descNode = FocusNode();
  static const _PANEL_HEADER_HEIGHT = 32.0;
  AnimationController _controller;
  ScrollController scrlcont = new ScrollController();

  String tddate = tday + '/' + tmonth + '/' + tyear;

  bool _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      var dbhelper = DBHelper();
      var rec = Records();
      rec.userid = userid;
      rec.doctor = doctor;
      rec.hospital = hospital;
      rec.problem = problem;
      rec.date = tddate;
      rec.img1 = _fstimg;
      rec.img2 = _sndimg;
      rec.img3 = _trdimg;
      rec.img4 = _frdimg;

      dbhelper.addRecord(rec);
      print(
          "User added + rec id ${rec.recid}/user id ${rec.userid}/doc ${rec.doctor}/ hos ${rec.hospital}/pro ${rec.problem}/date ${rec.date}/${rec.img1}/${rec.img2}/${rec.img3}/${rec.img4}");
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 0.0, vsync: this);
    setState(() {
      uid = userid;
    });
  }

  startTimeout([int milliseconds]) {
    var duration = timeout;
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    // callback function
    _visible = true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool add = true;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: maintheme,
        elevation: 0.0,
        title: new Text("MEDICAL RECORDS"),
      ),
      floatingActionButton: _visible
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              tooltip: 'Create Medical Record',
              child: Icon(add ? Icons.add : Icons.close),
              onPressed: () {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                FocusScope.of(context).requestFocus(new FocusNode());
                _reset();
                setState(() {
                  add ? add = false : add = true;
                  _visible = false;
                  Timer(const Duration(milliseconds: 200), () {
                    setState(() {
                      _visible = true;
                    });
                  });
                });
              },
            )
          : null,
      body: new LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  void _reset() {
    doc.clear();
    hos.clear();
    pro.clear();
    setState(() {
      _fstimg = null;
      _sndimg = null;
      _trdimg = null;
      _frdimg = null;
    });
    scrlcont.animateTo(0.0,
        duration: const Duration(milliseconds: 10), curve: Curves.easeOut);
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final double _imgwidth = (MediaQuery.of(context).size.width) / 2.25;
    final double _formwidth = (MediaQuery.of(context).size.width) / 1.2;
    final double _btnwidth = _imgwidth * 1.6;
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    return new Container(
      color: maintheme,
      child: new Stack(
        children: <Widget>[
          _recordlist(),
          new PositionedTransition(
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
                        _inputform(_formwidth),
                        _imageinput(_imgwidth),
                        _savebutton(_btnwidth)
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

  Widget _savebutton(_btnwidth) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: RaisedButton(
        color: Colors.cyan,
        child: Container(
          alignment: Alignment.center,
          width: _btnwidth,
          child: Text(
            'SAVE',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          if (_submit()) {
            _showMessage('Medical Record', 'Successfully created');
            _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
          } else {
            _showMessage('Medical Record', 'Creation failed');
          }
        },
      ),
    );
  }

  void _showMessage(String dtitle, String dcontent) {
    showDialog(
        context: context,
        builder: (context) => Container(
              child: AlertDialog(
                title: Text(dtitle),
                content: Text(dcontent),
                actions: <Widget>[
                  FlatButton(
                    child: Text('CLOSE'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
  }

  Widget _recordlist() {
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
                            child: Column(
                              children: <Widget>[
                                Text('Date : ${snapshot.data[index].date}'),
                                Text('Doctor : ${snapshot.data[index].doctor}'),
                                Text(
                                    'Hospital : ${snapshot.data[index].hospital}'),
                                Text(
                                    'Problem : ${snapshot.data[index].problem}'),
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child:
                                      Image.memory(snapshot.data[index].img1),
                                )
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

  Widget _inputform(double formwidth) {
    double _inputwidth = formwidth - 50;
    return Form(
      key: formKey,
      child: Container(
          width: formwidth,
          padding: EdgeInsets.only(top: 32.0, bottom: 30.0),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10.0, bottom: 5.0),
                      alignment: Alignment.topRight,
                      child: Text(
                        tddate,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4.0),
                      width: _inputwidth,
                      child: TextFormField(
                        enabled: true,
                        controller: doc,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.cyan),
                            labelText: 'Doctor'),
                        validator: (val) =>
                            val.isEmpty ? "Doctor name is required" : null,
                        onSaved: (val) => this.doctor = val,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(hospitalNode);
                        },
                      ),
                    ),
                    Container(
                      width: _inputwidth,
                      padding: EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: hos,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.cyan),
                            labelText: 'Hospital'),
                        focusNode: hospitalNode,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(descNode),
                        validator: (val) =>
                            val.isEmpty ? "Hospital name is required" : null,
                        onSaved: (val) => this.hospital = val,
                      ),
                    ),
                    Container(
                      width: _inputwidth,
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: TextFormField(
                        controller: pro,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.cyan),
                            labelText: 'Problem'),
                        focusNode: descNode,
                        validator: (val) =>
                            val.isEmpty ? "Problem name is required" : null,
                        onSaved: (val) => this.problem = val,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _imageinput(double imgwidth) {
    double _iconsize = imgwidth / 5.8;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _imgPicker1(imgwidth, _iconsize),
              _imgPicker2(imgwidth, _iconsize)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _imgPicker3(imgwidth, _iconsize),
              _imgPicker4(imgwidth, _iconsize)
            ],
          ),
        ],
      )),
    );
  }

  Future _gallerypicker1() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (f != null) {
        print(f.path);
        _fstimg = f.readAsBytesSync();
      }
    });
  }

  Future _camerapicker1() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (f != null) {
        _fstimg = f.readAsBytesSync();
      }
    });
  }

  Future _gallerypicker2() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (f != null) {
        print(f.path);
        _sndimg = f.readAsBytesSync();
      }
    });
  }

  Future _camerapicker2() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (f != null) {
        _sndimg = f.readAsBytesSync();
      }
    });
  }

  Future _gallerypicker3() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (f != null) {
        print(f.path);
        _trdimg = f.readAsBytesSync();
      }
    });
  }

  Future _camerapicker3() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (f != null) {
        _trdimg = f.readAsBytesSync();
      }
    });
  }

  Future _gallerypicker4() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (f != null) {
        print(f.path);
        _frdimg = f.readAsBytesSync();
      }
    });
  }

  Future _camerapicker4() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (f != null) {
        _frdimg = f.readAsBytesSync();
      }
    });
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

  Widget _imgPicker1(imgwidth, _iconsize) {
    return Container(
      width: imgwidth,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: _fstimg == null
                          ? DecorationImage(
                              fit: BoxFit.none,
                              image: AssetImage('images/imgg.png'))
                          : DecorationImage(
                              fit: BoxFit.cover, image: MemoryImage(_fstimg)),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(16.0)),
                      gradient: const LinearGradient(
                          begin: const Alignment(0.0, 1.0),
                          end: const Alignment(0.0, 0.3),
                          colors: const <Color>[
                            const Color(0x60000000),
                            const Color(0x00000000)
                          ])),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: _fstimg == null
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _fstimg = null;
                                  });
                                },
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: _iconsize,
                                color: _fstimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              highlightColor: Colors.cyan[100],
                              onPressed: () => _camerapicker1()),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: IconButton(
                              icon: Icon(
                                Icons.image,
                                size: _iconsize,
                                color: _fstimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              onPressed: () => _gallerypicker1()),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _imgPicker2(imgwidth, _iconsize) {
    return Container(
      width: imgwidth,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: _sndimg == null
                          ? DecorationImage(
                              fit: BoxFit.none,
                              image: AssetImage('images/imgg.png'))
                          : DecorationImage(
                              fit: BoxFit.cover, image: MemoryImage(_sndimg)),
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(16.0)),
                      gradient: const LinearGradient(
                          begin: const Alignment(0.0, 1.0),
                          end: const Alignment(0.0, 0.3),
                          colors: const <Color>[
                            const Color(0x60000000),
                            const Color(0x00000000)
                          ])),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: _sndimg == null
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _sndimg = null;
                                  });
                                },
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: _iconsize,
                                color: _sndimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              highlightColor: Colors.cyan[100],
                              onPressed: () => _camerapicker2()),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: IconButton(
                              icon: Icon(
                                Icons.image,
                                size: _iconsize,
                                color: _sndimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              onPressed: () => _gallerypicker2()),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _imgPicker3(imgwidth, _iconsize) {
    return Container(
      width: imgwidth,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: const Alignment(0.0, 1.0),
                        end: const Alignment(0.0, 0.3),
                        colors: const <Color>[
                          const Color(0x60000000),
                          const Color(0x00000000)
                        ]),
                    image: _trdimg == null
                        ? DecorationImage(
                            fit: BoxFit.none,
                            image: AssetImage('images/imgg.png'))
                        : DecorationImage(
                            fit: BoxFit.cover, image: MemoryImage(_trdimg)),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(16.0)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: _trdimg == null
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _trdimg = null;
                                  });
                                },
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: _iconsize,
                                color: _trdimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              highlightColor: Colors.cyan[100],
                              onPressed: () => _camerapicker3()),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: IconButton(
                              icon: Icon(
                                Icons.image,
                                size: _iconsize,
                                color: _trdimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              onPressed: () => _gallerypicker3()),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _imgPicker4(imgwidth, _iconsize) {
    return Container(
      width: imgwidth,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: _frdimg == null
                          ? DecorationImage(
                              fit: BoxFit.none,
                              image: AssetImage('images/imgg.png'))
                          : DecorationImage(
                              fit: BoxFit.cover, image: MemoryImage(_frdimg)),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(16.0)),
                      gradient: const LinearGradient(
                          begin: const Alignment(0.0, 1.0),
                          end: const Alignment(0.0, 0.3),
                          colors: const <Color>[
                            const Color(0x60000000),
                            const Color(0x00000000)
                          ])),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: _frdimg == null
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _frdimg = null;
                                  });
                                },
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: _iconsize,
                                color: _frdimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              highlightColor: Colors.cyan[100],
                              onPressed: () => _camerapicker4()),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: imgwidth / 1.3, right: 2.0),
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: IconButton(
                              icon: Icon(
                                Icons.image,
                                size: _iconsize,
                                color: _frdimg == null
                                    ? Colors.white
                                    : Colors.cyan,
                              ),
                              onPressed: () => _gallerypicker4()),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
