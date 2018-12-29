import 'package:flutter/material.dart';
import 'dart:async';
import '../../Database/database.dart';
import '../../Models/records_book/record_book.dart';
// import '../../Views/records_book/medrecords.dart';

class ProfileScreen extends StatefulWidget {
  final String lan;
  ProfileScreen({@required this.lan});
  ProfileScreenState createState() => ProfileScreenState(language: lan);
}

Future<List<User>> fetchusersFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<User>> users = dbHelper.fetchUserList();
  return users;
}

var maintheme = Color(0xFF72BB53);

class SettingData {
  static const String edit = 'Edit';
  static const String delete = 'Delete';

  static const List<String> languages = <String>[edit, delete];
}

class ProfileScreenState extends State<ProfileScreen> {
  var loading = true;
  Future<List<User>> fetchusersFromDatabase() async {
    var dbHelper = DBHelper();
    Future<List<User>> users = dbHelper.fetchUserList();
    setState(() {
      loading = true;
    });
    return users;
  }

  final String language;
  ProfileScreenState({@required this.language});
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var name;
  var editname;

  bool _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      var dbhelper = DBHelper();
      var user = User();
      user.name = name;
      dbhelper.addUser(user);
      print("User added");
      return true;
    } else {
      return false;
    }
  }

  void _update(int id) {
    if (this.formKey2.currentState.validate()) {
      formKey2.currentState.save();
      var dbhelper = DBHelper();
      var user = User();
      user.id = id;
      user.name = editname;
      dbhelper.updateUser(user);
      print("User updated");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILES',
          style: TextStyle(color: Theme.of(context).textTheme.title.color),
        ),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: maintheme,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: maintheme,
        tooltip: 'Create Profile',
        child: Icon(
          Icons.person_add,
          size: 32.0,
        ),
        onPressed: _createProfile,
      ),
      body: _profileBody(),
    );
  }

  void _createProfile() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: 59.0,
            child: AlertDialog(
              title: Text(
                'Create Profile',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Profile Name'),
                  validator: (val) =>
                      val.isEmpty ? "Profile name is required" : null,
                  onSaved: (val) => this.name = val,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Color.fromRGBO(114, 187, 83, 0.15),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  splashColor: Color.fromRGBO(114, 187, 83, 0.15),
                  highlightColor: Colors.transparent,
                  child: Text(
                    'CREATE',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_submit() == true) {
                        Navigator.pop(context);
                      }
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  _profileBody() {
    return Container(
        child: new FutureBuilder<List<User>>(
      future: fetchusersFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return new ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                // return new Card(
                // child: ListTile(
                //   subtitle: Text(snapshot.data[index].id.toString()),
                //   title: new Text(snapshot.data[index].name,
                //       style: new TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 18.0)),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => MedRec(
                //                   id: snapshot.data[index].id,
                //                 )));
                //   },
                //   trailing: PopupMenuButton<String>(
                //     itemBuilder: (BuildContext context) {
                //       return SettingData.languages.map((String func) {
                //         return PopupMenuItem<String>(
                //           value: func,
                //           child: Text(func),
                //         );
                //       }).toList();
                //     },
                //     onSelected: (String choice) {
                //       if(choice=="Edit"){
                //         showDialog(
                //                     context: context,
                //                     builder: (BuildContext context) =>
                //                         Container(
                //                           child: AlertDialog(
                //                             title: Row(
                //                               children: <Widget>[
                //                                 Icon(Icons.person),
                //                                 Text(snapshot
                //                                     .data[index].name),
                //                               ],
                //                             ),
                //                             content: Form(
                //                               key: formKey2,
                //                               child: TextFormField(
                //                                 keyboardType:
                //                                     TextInputType.text,
                //                                 decoration: InputDecoration(
                //                                     labelText:
                //                                         'Profile Name'),
                //                                 validator: (val) =>
                //                                     val.length == 0
                //                                         ? "Profile name is required"
                //                                         : null,
                //                                 autofocus: true,
                //                                 initialValue: snapshot
                //                                     .data[index].name,
                //                                 onSaved: (val) =>
                //                                     this.editname = val,
                //                               ),
                //                             ),
                //                             actions: <Widget>[
                //                               FlatButton(
                //                                 child: Text('CANCEL'),
                //                                 onPressed: () {
                //                                   Navigator.pop(context);
                //                                 },
                //                               ),
                //                               FlatButton(
                //                                 child: Text('EDIT'),
                //                                  onPressed: () {
                //                                   setState(() {
                //                                     _update(snapshot
                //                                         .data[index].id);
                //                                   });
                //                                   Navigator.pop(context);
                //                                 },
                //                               )
                //                             ],
                //                           ),
                //                         ));
                //       }
                //       else{
                //         showDialog(
                //                     context: context,
                //                     builder: (BuildContext context) =>
                //                         Container(
                //                           child: AlertDialog(
                //                             title: Row(
                //                               children: <Widget>[
                //                                 Icon(Icons.person),
                //                                 Text(snapshot
                //                                     .data[index].name),
                //                               ],
                //                             ),
                //                             actions: <Widget>[
                //                               FlatButton(
                //                                 child: Text('CANCEL'),
                //                                 onPressed: () {
                //                                   Navigator.pop(context);
                //                                 },
                //                               ),
                //                               FlatButton(
                //                                 child: Text('DELETE'),
                //                                 onPressed: () {
                //                                   DBHelper dh =
                //                                       new DBHelper();
                //                                   setState(() {
                //                                     dh.deleteUser(snapshot
                //                                         .data[index].id);
                //                                   });
                //                                   Navigator.pop(context);
                //                                 },
                //                               )
                //                             ],
                //                             content: Text(
                //                                 'Do you want to delete this profile?'),
                //                           ),
                //                         ));
                //       }
                //     },
                //   ),
                // ),
                //);
                return Padding(
                  padding: EdgeInsets.only(
                      top: 6.0, bottom: 4.0, left: 12.0, right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      print('clicked');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: Color(0xFF72BB53))),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Color(0xFF72BB53),
                              ),
                              itemBuilder: (BuildContext context) {
                                return SettingData.languages.map((String func) {
                                  return PopupMenuItem<String>(
                                    value: func,
                                    child: Text(func),
                                  );
                                }).toList();
                              },
                              onSelected: (String choice) {
                                if (choice == "Edit") {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          Container(
                                            child: AlertDialog(
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text(
                                                    snapshot.data[index].name,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ],
                                              ),
                                              content: Form(
                                                key: formKey2,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Profile Name'),
                                                  validator: (val) => val
                                                              .length ==
                                                          0
                                                      ? "Profile name is required"
                                                      : null,
                                                  autofocus: true,
                                                  initialValue:
                                                      snapshot.data[index].name,
                                                  onSaved: (val) =>
                                                      this.editname = val,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  splashColor: Color.fromRGBO(
                                                      114, 187, 83, 0.15),
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  splashColor: Color.fromRGBO(
                                                      114, 187, 83, 0.15),
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: Text('EDIT',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)),
                                                  onPressed: () {
                                                    setState(() {
                                                      _update(snapshot
                                                          .data[index].id);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          Container(
                                            child: AlertDialog(
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(Icons.person),
                                                  Text(snapshot
                                                      .data[index].name),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('CANCEL'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  splashColor: Color.fromRGBO(
                                                      114, 187, 83, 0.15),
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: Text('DELETE'),
                                                  onPressed: () {
                                                    DBHelper dh =
                                                        new DBHelper();
                                                    setState(() {
                                                      dh.deleteUser(snapshot
                                                          .data[index].id);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                              content: Text(
                                                  'Do you want to delete this profile?'),
                                            ),
                                          ));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return Center(child: new Text("No Data found"));
        }
      },
    ));
  }
}
