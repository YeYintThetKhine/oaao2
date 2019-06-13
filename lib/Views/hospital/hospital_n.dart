import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Models/hospital/clinic.dart';
import 'hospitallist_n.dart';
import '../../Animations/scale.dart';
import 'package:connectivity/connectivity.dart';

class Hospital extends StatefulWidget {
  final language;
  Hospital(this.language);
  _HospitalState createState() => _HospitalState(language);
}

class _HospitalState extends State<Hospital>
    with SingleTickerProviderStateMixin {
  String type;
  final language;
  var lan;
  var title;
  bool loading;
  var typearr = [];
  Set<HType> category = Set();
  HType htype;
  Set<HType> cat = Set();
  _HospitalState(this.language);

  Animation animation;
  AnimationController animationController;
  var _connection;
  var _conStatus = "Unknown";
  Connectivity connectivity;
  var subscription;

  _loadData() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('hospital_type')
        .child(lan)
        .child('type')
        .once()
        .then((DataSnapshot snap) {
      setState(() {
        type = snap.value;
        var list = type.split(',');
        for (String item in list) {
          typearr.add(item.trim());
        }
        _loadCount();
      });
    });
  }

  _checkConnection() {
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          _connection = true;
          _loadData();
        });
      } else {
        setState(() {
          _connection = false;
          _conStatus = "No Internet Connection!";
        });
      }
    });
  }

  _loadCount() {
    var count;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    for (var types in typearr) {
      ref
          .child('hospitals')
          .child(lan)
          .child(types)
          .once()
          .then((DataSnapshot snap) {
        setState(() {
          if (snap.value == null) {
            count = 0;
          } else {
            count = snap.value.length;
          }
          category.add(HType(title: types, count: count));
        });
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();

    loading = true;
    if (language == "mm") {
      lan = "mm";
      title = "ဆေးရုံအမျိုးအစား";
    } else {
      lan = "en";
      title = "HOSPITAL TYPE";
    }
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color(0xFF72BB53),
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).textTheme.title.color),
        ),
      ),
      body: Container(
        child: _connection == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Icon(
                        Icons.signal_cellular_connected_no_internet_4_bar,
                        color: Theme.of(context).primaryColor,
                        size: 36.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _conStatus,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: typearr.length != category.length || loading
                    ? Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF72BB53)),
                          ),
                        ),
                      )
                    : AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget widget) =>
                            ListView.builder(
                                itemCount: typearr.length,
                                itemBuilder: (context, index) => Transform(
                                    transform: Matrix4.translationValues(
                                        animation.value *
                                            MediaQuery.of(context).size.width,
                                        0.0,
                                        0.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 4.0, right: 4.0),
                                      child: Card(
                                        elevation: 4.0,
                                        child: ListTile(
                                          title: Text(
                                              category.elementAt(index).title,
                                              style: TextStyle(
                                                  color: Color(0xFF72BB53))),
                                          trailing: CircleAvatar(
                                            backgroundColor: Color(0xFF72BB53),
                                            maxRadius: 13.6,
                                            foregroundColor: Colors.white,
                                            child: Text(category
                                                .elementAt(index)
                                                .count
                                                .toString()),
                                          ),
                                          onTap: () {
                                            if (category
                                                    .elementAt(index)
                                                    .count !=
                                                0)
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                      widget: HospitalList(
                                                    hostype: category
                                                        .elementAt(index)
                                                        .title
                                                        .toString(),
                                                    language: language,
                                                  )));
                                          },
                                        ),
                                      ),
                                    )))),
              ),
      ),
    );
  }
}
