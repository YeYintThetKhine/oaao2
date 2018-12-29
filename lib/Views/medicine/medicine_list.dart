import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Models/medicine/medicine.dart';
import 'package:material_search/material_search.dart';
import 'medicine_detail.dart';
import '../../Animations/slide_right_in.dart';

class MedicineList extends StatefulWidget {
  final String language;
  final String appbarTitle;
  MedicineList({this.language, this.appbarTitle});
  @override
  _MedicineListState createState() =>
      _MedicineListState(language: language, appbarTitle: appbarTitle);
}

class _MedicineListState extends State<MedicineList> {
  final String language;
  final String appbarTitle;
  _MedicineListState({this.language, this.appbarTitle});
  var _isLoading = false;
  var _connection = true;
  var _conStatus = 'Unknown';
  Connectivity connectivity;
  var subscription;
  var _isNull = false;
  Medicine med;
  List<Medicine> medList = <Medicine>[];
  List<String> medNames = <String>[];
  String searchName;

  @override
  void initState() {
    super.initState();
    _checkCon();
  }

  _checkCon() {
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          _connection = true;
          _getMedicine();
        });
      } else {
        setState(() {
          _isLoading = true;
          _connection = false;
          _conStatus = "No Internet Connection!";
        });
      }
    });
  }

  _getMedicine() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('medicines').child(language).once().then((DataSnapshot dataSnap) {
      if (dataSnap.value == null) {
        setState(() {
          _isNull = true;
        });
      } else {
        var medTypes = dataSnap.value.keys;
        for (var type in medTypes) {
          ref
              .child('medicines')
              .child(language)
              .child(type)
              .once()
              .then((DataSnapshot snap) {
            var keys = snap.value.keys;
            var data = snap.value;
            for (var key in keys) {
              Medicine med = new Medicine(
                medId: key,
                medImg: data[key]['img_$language'],
                medName: data[key]['name_$language'],
                medType: data[key]['type_$language'],
                medManuf: data[key]['manufacture_$language'],
                medDesc: data[key]['description_$language'],
              );
              medList.add(med);
              medNames.add(med.medName);
            }
          });
        }
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              iconColor: Theme.of(context).iconTheme.color,
              barBackgroundColor: Theme.of(context).primaryColor,
              placeholder: 'Search',
              results: medNames
                  .map((String v) => new MaterialSearchResult<String>(
                        value: v,
                        text: "$v",
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => routeToDetailPage(value),
              onSubmit: (String value) => routeToDetailPage(value),
            ),
          );
        });
  }

  routeToDetailPage(String medname) {
    for (Medicine medicine in medList) {
      if (medname == medicine.medName) {
        Navigator.push(
            context,
            SlideRightAnimation(
                widget: MedicineDetail(
              medicine: medicine,
            )));
      }
    }
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      setState(() => searchName = value as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                appbarTitle,
                style:
                    TextStyle(color: Theme.of(context).textTheme.title.color),
              ),
              iconTheme: Theme.of(context).iconTheme,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _showMaterialSearch(context);
                  },
                )
              ],
            ),
            body: _connection == false
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Icon(
                          Icons.signal_cellular_connected_no_internet_4_bar,
                          color: Theme.of(context).primaryColor,
                          size: 64.0,
                        ),
                      ),
                      Text(
                        _conStatus,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0),
                      ),
                    ],
                  ))
                : _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : _isNull == true
                        ? Center(
                            child: Text(
                              "No Medicines",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0),
                            ),
                          )
                        : Container()
            // : ListView.builder(
            //     itemCount: medList.length,
            //     itemBuilder: (context, i) {
            //       return Container(
            //         margin:
            //             EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10.0),
            //             border: Border.all(
            //                 width: 1.0,
            //                 color: Theme.of(context).primaryColor)),
            //         child: FlatButton(
            //           padding:
            //               EdgeInsets.only(top: 12.0, bottom: 12.0),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 SlideRightAnimation(
            //                     widget: MedicineDetail(
            //                   medicine: medList[i],
            //                 )));
            //           },
            //           child: ListTile(
            //             leading: Image.network(
            //               medList[i].medImg,
            //               width: 62.0,
            //             ),
            //             title: Text(
            //               medList[i].medName,
            //               style: TextStyle(
            //                   color: Theme.of(context).primaryColor,
            //                   fontSize: 18.0),
            //             ),
            //             trailing: Icon(
            //               Icons.keyboard_arrow_right,
            //               color: Theme.of(context).primaryColor,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   )
            );
      },
    );
  }
}