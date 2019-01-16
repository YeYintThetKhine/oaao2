import 'package:flutter/material.dart';
import '../../Models/records_book/record_book.dart';
import '../../Database/database.dart';
import '../records_book/images_edit.dart';
List<ImageData> imagelist;
class RecordEdit extends StatefulWidget {
  final record;
  RecordEdit({@required this.record});

  _RecordEditState createState() => _RecordEditState(record: record);
}

class _RecordEditState extends State<RecordEdit> {
  Records record;
  _RecordEditState({@required this.record});

  DBHelper dbHelper = DBHelper();

  List sample = List();
  var formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    docCtrl.text = record.doctor;
    hosCtrl.text = record.hospital;
    proCtrl.text = record.problem;
    setState(() {
                      fetchImages();
        });
  }
  
  var docNode = FocusNode();
  var hosNode = FocusNode();
  var proNode = FocusNode();

  bool docEdit = false;
  bool hosEdit = false;
  bool proEdit = false;

  var doctor;
  var hospital;
  var problem;

  var docCtrl = TextEditingController();
  var hosCtrl = TextEditingController();
  var proCtrl = TextEditingController();

  List<ImageData> rest;
  
  Future<List<ImageData>> fetchimagesFromDatabase() async {
    Future<List<ImageData>> records =
        dbHelper.fetchImageDataList(userid: record.userid, recid: record.recid);
    var rec;
    setState(() {
          rec = records;
        });  
    return rec;
  }

  fetchImages() async{
    var result;
    result = await dbHelper.fetchImageDataList(userid: record.userid, recid: record.recid);

    setState(() {
          imagelist = result;
        });
  }

  bool _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      var dbhelper = DBHelper();
      var rec = Records();
      rec.userid = record.userid;
      rec.recid = record.recid;
      rec.doctor = doctor;
      rec.hospital = hospital;
      rec.problem = problem;
      rec.date = record.date;

      dbhelper.updateRecords(rec);
      return true;
    } else {
      return false;
    }
  }
  @override
    void dispose() {
      docNode.dispose();
      hosNode.dispose();
      proNode.dispose();
      super.dispose();
    }
  
  Widget _recordImages() {
    return FutureBuilder<List<ImageData>>(
      future: fetchimagesFromDatabase(),
      builder: (context, snapshot) => (snapshot.hasData &&
              snapshot.data.length != 0)
          ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (context,index)=>
            Container(
              child: Image.memory(snapshot.data[index].imgData,
              fit: BoxFit.cover,),
            )
          )
          : Center(
                  child: Container(
                    color: Colors.grey[300],
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/image.jpg'),
                  ),
                )
    );
  }

  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width / 1.5;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('EDIT RECORD', style: TextStyle(color: Colors.white)),
      ),

      body:SingleChildScrollView(
        child:  Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: boxWidth,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: TextFormField(
                          focusNode: docNode,
                          controller: docCtrl,
                          enabled: docEdit ? true : false,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Color(0xFF72BB53)),
                              labelText: 'Doctor',
                              counterText: 'Doctor Name'),
                          validator: (val) =>
                              val.isEmpty ? "Doctor name is required" : null,
                          onSaved: (val) => this.doctor = val,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        // child: RaisedButton(
                          child: RaisedButton(
                          color: Color(0xFF72BB53),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                width: 2,
                                color: Color(0xFF72BB53)
                              )
                              ),
                          child: docEdit?Text('Confirm'):Text('Edit'),
                          onPressed: () {
                            setState(() {
                              if (docEdit == false) {
                                docEdit = true;
                                docCtrl.text = docCtrl.text;
                                FocusScope.of(context).requestFocus(docNode);
                              } else {
                                docEdit = false;
                                if (_submit() == true) {
                                  docCtrl.text = docCtrl.text;
                                  FocusNode();
                                  record.doctor = docCtrl.text;
                                  print('Doctor Updated');
                                }
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: boxWidth,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: TextFormField(
                          focusNode: hosNode,
                          controller: hosCtrl,
                          enabled: hosEdit ? true : false,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Color(0xFF72BB53)),
                              labelText: 'Hospital',
                              counterText: 'Hospital Name'),
                          validator: (val) =>
                              val.isEmpty ? "Hospital name is required" : null,
                          onSaved: (val) => this.hospital = val,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          color: Color(0xFF72BB53),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: hosEdit?Text('Confirm'):Text('Edit'),
                          onPressed: () {
                            setState(() {
                              if (hosEdit == false) {
                                hosEdit = true;
                                hosCtrl.text = hosCtrl.text;
                                FocusScope.of(context).requestFocus(hosNode);
                              } else {
                                hosEdit = false;
                                if (_submit() == true) {
                                  hosCtrl.text = hosCtrl.text;
                                  FocusNode();
                                  print('Hospital Updated');
                                  record.hospital = hosCtrl.text;
                                }
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: boxWidth,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: TextFormField(
                          focusNode: proNode,
                          controller: proCtrl,
                          enabled: proEdit ? true : false,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Color(0xFF72BB53)),
                              labelText: 'Problem',
                              counterText: 'Problem Description'),
                          validator: (val) =>
                              val.isEmpty ? "Problem name is required" : null,
                          onSaved: (val) => this.problem = val,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          color: Color(0xFF72BB53),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: proEdit?Text('Confirm'):Text('Edit'),
                          onPressed: () {
                            setState(() {
                              if (proEdit == false) {
                                proEdit = true;
                                proCtrl.text = proCtrl.text;
                                FocusScope.of(context).requestFocus(proNode);
                              } else {
                                proEdit = false;
                                if (_submit() == true) {
                                  proCtrl.text = proCtrl.text;
                                  FocusNode();
                                  record.problem = proCtrl.text;
                                  print('Problem Updated');
                                }
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                          textColor: Color(0xFF72BB53),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                color: Color(0xFF72BB53),
                                width: 2,
                              )
                              ),
                          child: Text('Edit'),
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:(context)=>ImagesEdit(imglist: imagelist,record: record,)
                                
                              )
                            );
                            print('hello');
                          },
            ),
            ),
            Container(
              color: Colors.lightGreen[300],
              height: MediaQuery.of(context).size.height/2.5,
              child: _recordImages(),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
