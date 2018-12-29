import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Models/hospital/clinic.dart';
import 'hospitallist_n.dart';
import '../../Animations/scale.dart';

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
        typearr = type.split(',');
        print(type);
        _loadCount();
      });
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
    print('done');
    loading = false;
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
    if (language == "Myanmar") {
      lan = "mm";
      title = "ဆေးရုံအမျိုးအစား";
    } else {
      lan = "en";
      title = "HOSPITAL TYPE";
    }
    _loadData();
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
      body: typearr.length != category.length || loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72BB53)),
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
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Card(
                              elevation: 4.0,
                              child: ListTile(
                                title: Text(category.elementAt(index).title,
                                    style: TextStyle(color: Color(0xFF72BB53))),
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
                                  if (category.elementAt(index).count != 0)
                                    Navigator.push(
                                        context,
                                        // MaterialPageRoute(
                                        //   builder: (context)=>HospitalList(hostype: category.elementAt(index).title.toString(),)
                                        // )
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
    );
  }
}
