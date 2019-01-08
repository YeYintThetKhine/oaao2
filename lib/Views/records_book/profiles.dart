import 'package:flutter/material.dart';
import 'dart:async';
import '../../Database/database.dart';
import '../../Models/records_book/record_book.dart';
import '../../Views/records_book/medrecords.dart';
import '../../Views/landing_page/login_screen.dart';
import '../../Auth/auth.dart';

class ProfileScreen extends StatefulWidget {
  final String lan;
  final AuthFunction authFunction;
  ProfileScreen({@required this.lan, this.authFunction});
  ProfileScreenState createState() => ProfileScreenState(language: lan);
}

enum AuthStatus {
  notSignedIn,
  signedIn,
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
  DBHelper db = DBHelper();
  var loading = true;
  AuthStatus authStatus = AuthStatus.notSignedIn;
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
  int count;

  _submit() async {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      var user = User();
      user.name = name;
      await db.addUser(user).catchError((onError) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('More than 5 profiles is not allowed'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      });
      setState(() {
        print("User added");
      });

      return true;
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

  void _routeToLogin() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  authFunction: Authentic(),
                  language: language,
                )));
  }

  @override
  void initState() {
    super.initState();
    widget.authFunction.getUser().then((user) {
      setState(() {
        authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "You are not signed in!",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _routeToLogin,
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.title.color),
                  ),
                )
              ],
            ),
          ),
        );
      case AuthStatus.signedIn:
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
                  return Padding(
                    padding: EdgeInsets.only(
                        top: 6.0, bottom: 4.0, left: 12.0, right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MedRec(
                                  id: snapshot.data[index].id,
                                )));
                      },
                      child: Container(
                        width: 250.0,
                        height: 80,
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
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Color(0xFF72BB53),
                                  size: 30.0,
                                ),
                                itemBuilder: (BuildContext context) {
                                  return SettingData.languages
                                      .map((String func) {
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
                                                          color: Theme.of(
                                                                  context)
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
                                                    initialValue: snapshot
                                                        .data[index].name,
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
                                                          color: Theme.of(
                                                                  context)
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
      ),
    );
  }
}
