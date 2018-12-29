import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  final loginFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  var _loading = false;

  @override
    void initState() {
      super.initState();
    }

    _accLogin() async {
      if(loginFormKey.currentState.validate()){
        setState(() {
          _loading = true;
        });
        try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
        await user.reload();
        user = await FirebaseAuth.instance.currentUser();
        bool flag = user.isEmailVerified;
        if(flag == false){
          setState(() {
            _loading = false;
          });
          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
              "Email is not verified! Please verify your email.",
              style: TextStyle(fontSize: 16.0),
            ),
            duration: Duration(seconds: 1),
          );
          _scaffold.currentState.showSnackBar(snackBar);
        }
        else{
          setState(() {
            _loading = false;
            Navigator.of(context).pushReplacementNamed('/HomeScreen');
          });
        }
        } catch (e) {
          print(e);
          setState(() {
            _loading = false;
          });
          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
              "Incorrect email address and password!",
              style: TextStyle(fontSize: 16.0),
            ),
            duration: Duration(seconds: 1),
          );
          _scaffold.currentState.showSnackBar(snackBar);
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          key: _scaffold,
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Login",
              style: TextStyle(color: Theme.of(context).textTheme.title.color),
            ),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                        alignment: Alignment.center,
                        height: device.height - 24 - kToolbarHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 32.0),
                              width: device.width - 64.0,
                              margin: EdgeInsets.only(top: 16.0),
                              child: Form(
                                key: loginFormKey,
                                  child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: email,
                                    validator: (value) => value.length == 0
                                        ? 'Email is required'
                                        : value.contains("@")
                                            ? null
                                            : 'Please enter valid email address.',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .color)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .color)),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 12.0),
                                        suffixIcon: Icon(Icons.email,
                                            color: Theme.of(context)
                                                .textTheme
                                                .title
                                                .color),
                                        suffixStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .title
                                                .color),
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .title
                                                .color),
                                        border: OutlineInputBorder()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: TextFormField(
                                    controller: password,
                                    onSaved: (value) => password.text =value,
                                      validator: (value) => value.length == 0
                                          ? 'Password is required'
                                          : null,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .title
                                                      .color)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .title
                                                      .color)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 6.0, horizontal: 12.0),
                                          suffixIcon: Icon(Icons.lock,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .color),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .color),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 16.0),
                                    child: _loading == true ?
                                    Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Theme.of(context).textTheme.title.color
                                        ),
                                      ),
                                    ) : FlatButton(
                                      highlightColor: Colors.transparent,
                                      splashColor:
                                          Color.fromRGBO(0, 0, 0, 0.05),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: device.width / 8,
                                          vertical: 12.0),
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .color),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      onPressed: _accLogin,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Theme.of(context)
                                                .textTheme
                                                .title
                                                .color),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
