import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Models/hospital/clinic.dart';
import '../../Views/hospital/hospitaldetail.dart';
import 'package:material_search/material_search.dart';
import '../../Animations/scale.dart';

class HospitalList extends StatefulWidget {
  final hostype;
  final language;
  HospitalList({@required this.hostype, @required this.language});

  @override
  _HospitalListState createState() =>
      new _HospitalListState(hospitaltype: hostype, languagechoice: language);
}

Set<Clinic> hoslist = Set();

class _HospitalListState extends State<HospitalList> {
  final hospitaltype;
  final languagechoice;
  Clinic clinic;
  Set names = new Set();
  String name = '';

  _HospitalListState({this.hospitaltype, this.languagechoice});
  // final palette = [
  //   {'#E53935': 0xFFE53935},
  //   {'#D81B60': 0xFFD81B60},
  //   {'#8E24AA': 0xFF8E24AA},
  //   {'#5E35B1': 0xFF5E35B1},
  //   {'#3949AB': 0xFF3949AB},
  //   {'#1E88E5': 0xFF1E88E5},
  //   {'#039BE5': 0xFF039BE5},
  //   {'#00ACC1': 0xFF00ACC1},
  //   {'#00897B': 0xFF00897B},
  //   {'#43A047': 0xFF43A047},
  //   {'#7CB342': 0xFF7CB342},
  //   {'#C0CA33': 0xFFC0CA33},
  // ];
  void initState() {
    super.initState();

    setState(() {
      loading = true;
      _loadReq();
    });
  }

  var loading = true;
  _loadReq() {
    hoslist.clear();
    String lan;
    if (languagechoice == 'mm') {
      setState(() {
        lan = 'mm';
      });
    } else {
      setState(() {
        lan = 'en';
      });
    }

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('hospitals')
        .child(lan)
        .child(hospitaltype)
        .once()
        .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      setState(() {
        for (var key in keys) {
          Clinic c = new Clinic(
              clinicimg: data[key]['img_$lan'],
              name: data[key]['name_$lan'],
              location: data[key]['location_$lan'],
              telephone: data[key]['phone_$lan'],
              fax: data[key]['fax_$lan'],
              email: data[key]['email'],
              website: data[key]['website'],
              facebook: data[key]['facebook'],
              type: data[key]['type_$lan'],
              map: data[key]['map']);
          hoslist.add(c);
          names.add(c.name);
        }
      });
    });
    setState(() {
      loading = false;
    });
  }

  _showMaterialSearch() {
    Navigator.of(context)
        .push(_buildMaterialSearchPage())
        .then((dynamic value) {
      setState(() => name = value as String);
    });
  }

  _buildMaterialSearchPage() {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              barBackgroundColor: Color(0xFF72BB53),
              iconColor: Colors.white,
              placeholder: 'Search',
              results: names
                  .map((dynamic v) => MaterialSearchResult<String>(
                        icon: Icons.local_hospital,
                        value: v,
                        text: "$v",
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => redirectNextPage(value),
              onSubmit: (String value) => redirectNextPage(value),
            ),
          );
        });
  }

  redirectNextPage(String value) {
    for (Clinic c in hoslist) {
      if (c.name == value) {
        Navigator.push(
            context,
            ScaleRoute(
                widget: HospitalDetail(todisplay: c, lan: languagechoice)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Color(0xFF72BB53),
          title: new Text(
            hospitaltype,
            style: TextStyle(color: Theme.of(context).textTheme.title.color),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _showMaterialSearch();
              },
            )
          ]),
      body: new Container(
          child: loading || hoslist.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF72BB53))),
                )
              : ListView.builder(
                  itemCount: hoslist.length,
                  itemBuilder: (context, index) => new Hero(
                        tag: 'tx-${hoslist.elementAt(index).name}',
                        child: new GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(new NxtPageRoute(
                                hoslist.elementAt(index), languagechoice));
                          },
                          child: new Container(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 8.0, right: 8.0),
                            width: double.infinity,
                            child: Hero(
                              tag: 'txt-${hoslist.elementAt(index).name}',
                              child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0)),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 400.0,
                                        height: 125.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6.0),
                                                  topRight:
                                                      Radius.circular(6.0)),
                                              image: DecorationImage(
                                                  image: NetworkImage(hoslist
                                                      .elementAt(index)
                                                      .clinicimg),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              top: 5.0, bottom: 3.0),
                                          child: Text(
                                            hoslist.elementAt(index).name,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF72BB53)),
                                          )),
                                      Container(
                                          child: Row(children: [
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.place,
                                            color: Color(0xFF72BB53),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 4.0),
                                              child: Text(hoslist
                                                  .elementAt(index)
                                                  .location)),
                                        )
                                      ])),
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6.0),
                                                  bottomRight:
                                                      Radius.circular(6.0)),
                                              color: Color(0xFF72BB53)),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.phone,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  hoslist
                                                      .elementAt(index)
                                                      .telephone,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                )),
    );
  }
}

class NxtPageRoute extends MaterialPageRoute {
  NxtPageRoute(dynamic color, dynamic languagechoice)
      : super(
            builder: (context) => new HospitalDetail(
                  todisplay: color,
                  lan: languagechoice,
                ));
  // builder: (context) => new SecondPage(
  //        color:color,
  //      ));
}
