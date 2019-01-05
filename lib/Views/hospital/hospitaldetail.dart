import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/hospital/clinic.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

//Kaung Myat 2/8/2018
//to show hospital details

class HospitalDetail extends StatefulWidget {
  final Clinic todisplay;
  final String lan;
  HospitalDetail({@required this.todisplay, @required this.lan});
  DetailsState createState() =>
      DetailsState(details: todisplay, languagechoice: lan);
}

var facilitylist = [];
var fb;
var mail;
var location;
var ph;
var fax;
var site;
String lan;

class DetailsState extends State<HospitalDetail> {
  String flist;
  var facilitylist = [];
  Set<FacilityService> facility = new Set<FacilityService>();
  var coord = [];
  final Clinic details;
  final String languagechoice;
  DetailsState({@required this.details, @required this.languagechoice});

  /*_loadData() async {
    String url = "https://api.myjson.com/bins/1gvbe4"; //My own API for testing. 
    http.Response response = await http.get(url);
    setState(() {
      final membersJSON = json.decode(response.body);
      for (var memberJSON in membersJSON) {
        final member = new FacilityService(
          id: memberJSON["id"],
          clinicid: memberJSON["clinicid"],
          clinicname: memberJSON["clinicname"],
          servicename:memberJSON["servicename"] 
        );
        if (member.clinicname == details.name){
          facility.add(member);
        }
      }
    });
  }*/
  _loadData() {
    print("lan : " + lan);
    print("lanchoice : " + languagechoice);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('facility')
        .child(lan)
        .child(details.name)
        .once()
        .then((DataSnapshot snap) {
      var data = snap.value;
      if (snap.value != null) {
        FacilityService c = new FacilityService(
          servicename: data['services'],
        );
        setState(() {
          facility.add(c);
        });
      }
    });
  }

//to automatically perform _loadData function to decode JSON
  @override
  void initState() {
    super.initState();
    if (languagechoice == 'Myanmar') {
      setState(() {
        lan = 'mm';
        fb = "Facebook";
        mail = "Email";
        location = "တည်နေရာ";
        ph = "ဖုန်းနံပါတ်";
        fax = "Fax နံပါတ်";
        site = "Webiste";
      });
    } else {
      setState(() {
        lan = 'en';
        fb = "Facebook";
        mail = "Email";
        location = "Location";
        ph = "Phone";
        fax = "Fax";
        site = "Webiste";
      });
    }
    _loadData();
  }

  var phones = [];
  @override
  Widget build(BuildContext context) {
    if (facility.isEmpty == false) {
      for (FacilityService _service in facility) {
        setState(() {
          flist = _service.servicename;
          facilitylist = flist.split(',');
        });
      }
    }

    setState(() {
      String phnums = details.telephone;
      phones = phnums.split(',');
    });

    String mapcoor = details.map;
    coord = mapcoor.split(',');

    return Hero(
      tag: 'tx-${details.name}',
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _buildSilverAppBar(),
            _detailinfo(),
          ],
        ),
        //_facility()
      ),
    );
  }

//Showing map in a Dialog Box
  Widget showMap() {
    return new FlutterMap(
      options: MapOptions(
          center: LatLng(double.parse(coord[0]), double.parse(coord[1])),
          maxZoom: 18.0,
          minZoom: 14.0,
          zoom: 15.0),
      layers: [
        TileLayerOptions(
          urlTemplate: "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: [
          new Marker(
              point: LatLng(double.parse(coord[0]), double.parse(coord[1])),
              width: 70.0,
              height: 70.0,
              builder: (context) => Icon(
                    Icons.place,
                    color: Colors.red,
                  ))
        ])
      ],
    );
  }

//A widget to populate the container to show facilities and services
  Widget _text() {
    List<Widget> list = new List<Widget>();
    list.add(Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        languagechoice == 'Myanmar' ? 'ဝန်ဆောင်မှုများ' : 'Facility & Services',
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF72BB53)),
      ),
    ));

    //Seperating each and every facility & service with a divider to make them appear organized in the box
    for (String name in facilitylist) {
      list.add(Container(
        padding: EdgeInsets.only(left: 60.0),
        child: new Text(name),
        alignment: Alignment.centerLeft,
      ));
      list.add(Divider(
        color: Colors.white,
      ));
    }
    return new Column(
      children: list,
    );
  }

  Widget showPhNums() {
    var phlist = List<Widget>();
    for (var ph in phones) {
      phlist.add(Container(
        alignment: Alignment.center,
        child: ListTile(
          title: Text(ph),
          trailing: Icon(Icons.call, color: Color(0xFF72BB53)),
          onTap: () {
            var phnumss = ph.toString();
            var phnos = phnumss.replaceAll('-', '');
            launch('tel:$phnos');
          },
        ),
      ));
    }
    return Column(
      children: phlist,
    );
  }

//A box to show facilites and services
  Widget _facility() {
    return Container(
      //padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
      child: Container(child: _text()),
    );
  }

  void _showPhDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Container(
            child: AlertDialog(
              title: Text(
                'Choose a number',
                style: TextStyle(color: Color(0xFF666666)),
              ),
              content: SingleChildScrollView(
                  child: ListBody(
                children: <Widget>[showPhNums()],
              )),
              actions: <Widget>[
                FlatButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  final _appbarheight = 225.0; //Maximum height for collapsing app bar

  //Stylish App bar for attraction
  Widget _buildSilverAppBar() {
    return SliverAppBar(
      iconTheme: Theme.of(context).iconTheme,
      pinned: true,
      backgroundColor: Color(0xFF72BB53),
      expandedHeight: _appbarheight,
      flexibleSpace: FlexibleSpaceBar(
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image.network(
              details.clinicimg,
              fit: BoxFit.cover,
              height: _appbarheight,
            ),
            const DecoratedBox(
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                    begin: const Alignment(0.0, -1.0),
                    end: const Alignment(0.0, -0.08),
                    colors: const <Color>[
                      const Color(0x60000000),
                      const Color(0x00000000)
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Information of hospital
  Widget _detailinfo() {
    return new SliverList(
        delegate: new SliverChildBuilderDelegate(
            (context, position) => new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Container(
                        alignment: Alignment.center,
                        //padding: EdgeInsets.only(top: 10.0, bottom: 5.0),

                        child: Text(
                          details.name,
                          style: TextStyle(
                              fontSize: 25.0, color: Color(0xFF72BB53)),
                        ),
                      ),
                    ),
                    /*Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: new Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 5.0),
                                child: Icon(Icons.call),
                              ),
                              subtitle: Text(
                                'Call',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Launching Phone'),
                                    )
                                  );
                                launch('tel:${details.telephone}');
                              },
                            ),
                          ),
                          Container(
                            width: 100.0,
                            child: ListTile(
                                title: new Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 5.0),
                                  child: Icon(Icons.place),
                                ),
                                subtitle: Text(
                                  'Map',
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return new Container(
                                          child: AlertDialog(
                                            title: Text(
                                                'Location of ${details.name}'),
                                            content: SingleChildScrollView(
                                                child: ListBody(
                                              children: <Widget>[
                                                new Container(
                                                  child: new Container(
                                                    width: 500.0,
                                                    height: 300.0,
                                                    child: showMap(),
                                                  ),
                                                )
                                              ],
                                            )),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('CLOSE'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ),
                          Container(
                            width: 100.0,
                            child: ListTile(
                              title: new Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 5.0),
                                child: Icon(Icons.mail),
                              ),
                              subtitle: Text(
                                'Mail',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Launching Mail'),
                                    ));
                                launch('mailto:${details.email}');
                              },
                            ),
                          ),
                        ],
                      ),
                     ),*/
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.place,
                        color: Color(0xFF72BB53),
                      ),
                      title: Text(details.location),
                      subtitle: Text(location,
                          style: TextStyle(color: Colors.green[300])),
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new Container(
                                child: AlertDialog(
                                  title: Text('Location of ${details.name}'),
                                  content: SingleChildScrollView(
                                      child: ListBody(
                                    children: <Widget>[
                                      new Container(
                                        child: new Container(
                                          width: 500.0,
                                          height: 300.0,
                                          child: showMap(),
                                        ),
                                      )
                                    ],
                                  )),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('CLOSE'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.phone, color: Color(0xFF72BB53)),
                      title: Text(details.telephone),
                      subtitle:
                          Text(ph, style: TextStyle(color: Colors.green[300])),
                      onTap: () {
                        _showPhDialog();
                      },
                    ),
                    Divider(
                      indent: 65.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.print, color: Color(0xFF72BB53)),
                      title: Text(details.fax),
                      subtitle:
                          Text(fax, style: TextStyle(color: Colors.green[300])),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.mail, color: Color(0xFF72BB53)),
                      title: Text(details.email),
                      subtitle: Text(mail,
                          style: TextStyle(color: Colors.green[300])),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Launching Mail'),
                        ));
                        launch('mailto:${details.email}');
                      },
                    ),
                    Divider(
                      indent: 65.0,
                    ),
                    ListTile(
                      leading: ImageIcon(new AssetImage("assets/icons/web.png"),
                          color: Color(0xFF72BB53)),
                      title: Text(details.website),
                      subtitle: Text(site,
                          style: TextStyle(color: Colors.green[300])),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Launching Browser'),
                        ));
                        launch('https:${details.website}');
                      },
                    ),
                    Divider(
                      indent: 65.0,
                    ),
                    ListTile(
                      leading: ImageIcon(new AssetImage("assets/icons/fb.png"),
                          color: Color(0xFF72BB53)),
                      title: Text(details.facebook),
                      subtitle:
                          Text(fb, style: TextStyle(color: Colors.green[300])),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Launching Browser'),
                        ));
                        launch('https:${details.facebook}');
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: facility.isEmpty ? null : _facility(),
                    )
                  ],
                )),
            childCount: 1));
  }
}
