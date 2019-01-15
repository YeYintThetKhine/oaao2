import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../Animations/slide_right_in.dart';
import '../../Animations/slide_up_in.dart';
import '../../Views/doctor/doctor_type_list.dart';
import '../../Views/medicine/medicine_list.dart';
import '../../Views/knowledge/knowledge_main.dart';
import '../../Views/hospital/hospital_n.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Models/landing_page/news.dart';
import '../../Views/notification/reminder.dart';
import '../../Views/news/news.dart';
import '../../Views/ask_chat/chat_room.dart';
import '../../Database/database.dart';
import '../../Models/notification/reminder.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../Views/records_book/profiles.dart';
import '../../Auth/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuSetting {
  static const String myanmar = 'Myanmar';
  static const String english = 'English';

  static const List<String> languages = <String>[english, myanmar];
}

Future<List<Reminder>> reminderData() async {
  var dbHelper = DBHelper();
  Future<List<Reminder>> reminders = dbHelper.getReminderList();
  return reminders;
}

class HomeScreen extends StatefulWidget {
  final String language;
  final AuthFunction authFunction;
  HomeScreen({this.language, this.authFunction});
  @override
  _HomeScreenState createState() => _HomeScreenState(setLan: language);
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  final String setLan;
  _HomeScreenState({this.setLan});
  Animation animation, logoAnimation, menuAnimation;
  AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  News news;
  List<News> newsList = [];
  List<String> menuName = [
    'Records Book',
    'Doctors',
    'Hospitals',
    'Medicines',
    'Knowledge',
    'Ask & Chat'
  ];
  List<String> menuIcon = [
    'assets/icons/record_book.png',
    'assets/icons/doctor.png',
    'assets/icons/hospital.png',
    'assets/icons/medicine.png',
    'assets/icons/knowledge.png',
    'assets/icons/ask_chat.png'
  ];

  String menuNews = "News";
  String language = "en";
  double dynSize = 16.0;
  var reminderList = [];
  var appointList = [];
  List<String> reminderSortedDate = [];
  List<String> appointSortedDate = [];
  List<String> reminderSortedTime = [];
  List<String> appointSortedTime = [];
  var dateTimeReminderList = [];
  var dateTimeAppointList = [];
  var reminderTitle = 'No Reminder';
  var reminderTime = '';
  var appointTitle = 'No Appointment';
  var appointTime = '';
  var appointShowDate = '';
  var reminderShowDate = '';
  var scheduleDate = DateFormat("yyyy-MM-dd H:mm");
  var newsData = '';

  _getNews() {
    dbRef.child('news').child(language).once().then((DataSnapshot dataSnap) {
      if (dataSnap.value == Null) {
        setState(() {
          newsData = 'No News';
        });
      } else {
        var keys = dataSnap.value.keys;
        var value = dataSnap.value;
        for (var key in keys) {
          var data = News(
            newsDate: value[key]['date'],
            newsContent: value[key]['desc'],
            newsTitle: value[key]['heading'],
            newsImg: value[key]['img'],
          );
          newsList.add(data);
        }
        setState(() {
          _isLoading = true;
        });
      }
    });
  }

  @override
  void initState() {
    DBHelper dh = DBHelper();
    dh.initDb();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    logoAnimation = Tween(begin: 0.5, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    menuAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
    super.initState();
    if (setLan == 'mm') {
      setState(() {
        _languageChg("Myanmar");
      });
    } else {
      setState(() {
        _languageChg("English");
      });
    }
    _fetchReminder();
    _getNews();
  }

  _fetchReminder() {
    Future<List<Reminder>> remind = reminderData();
    remind.then((value) {
      for (var item in value) {
        if (item.remindType == "Reminder") {
          reminderList.add(item);
          var datenTime = item.remindDate + " " + item.remindTime;
          dateTimeReminderList.add(scheduleDate.parse(datenTime));
        } else {
          appointList.add(item);
          var datenTime = item.remindDate + " " + item.remindTime;
          dateTimeAppointList.add(scheduleDate.parse(datenTime));
        }
      }
      _sortnSplit(dateTimeReminderList, dateTimeAppointList);
      _checkReminder(value);
      _checkAppointment(value);
    });
  }

  _checkReminder(List<Reminder> data) {
    for (var i = 0; i < dateTimeReminderList.length; i++) {
      if (dateTimeReminderList[i].compareTo(DateTime.now()) >= 0) {
        for (var item in data) {
          if (reminderSortedDate[i] == item.remindDate &&
              reminderSortedTime[i] == item.remindTime) {
            setState(() {
              reminderShowDate = item.remindDate;
              reminderTime = item.remindTime;
              reminderTitle = item.remindAction;
            });
            break;
          }
        }
        break;
      }
    }
  }

  _checkAppointment(List<Reminder> data) {
    for (var i = 0; i < dateTimeAppointList.length; i++) {
      if (dateTimeAppointList[i].compareTo(DateTime.now()) >= 0) {
        for (var item in data) {
          if (appointSortedDate[i] == item.remindDate &&
              appointSortedTime[i] == item.remindTime) {
            setState(() {
              appointShowDate = item.remindDate;
              appointTime = item.remindTime;
              appointTitle = item.remindAction;
            });
            break;
          }
        }
        break;
      }
    }
  }

  _sortnSplit(List reminderlist, List appointlist) {
    dateTimeReminderList = reminderlist;
    dateTimeAppointList = appointlist;
    dateTimeReminderList.sort();
    dateTimeAppointList.sort();
    for (var item in dateTimeReminderList) {
      reminderSortedDate
          .add(item.toString().substring(0, item.toString().indexOf(" ")));
    }
    for (var item in dateTimeAppointList) {
      appointSortedDate
          .add(item.toString().substring(0, item.toString().indexOf(" ")));
    }
    for (var item in dateTimeReminderList) {
      reminderSortedTime
          .add(item.toString().substring(11, item.toString().lastIndexOf(":")));
    }
    for (var item in dateTimeAppointList) {
      appointSortedTime
          .add(item.toString().substring(11, item.toString().lastIndexOf(":")));
    }
  }

  _languageChg(String lang) {
    if (lang == "Myanmar") {
      setState(() {
        menuName = [
          'ဆေးမှတ်တမ်းစာအုပ်များ',
          'ဆရာဝန်များ',
          'ဆေးရုံများ',
          'ဆေးဝါးများ',
          'အသိပညာ',
          'အမေးအဖြေ'
        ];
        menuNews = "သတင်းများ";
        language = "mm";
        dynSize = 14.0;
        newsList.clear();
        _isLoading = false;
        _getNews();
      });
    } else {
      setState(() {
        menuName = [
          'Records Book',
          'Doctors',
          'Hospitals',
          'Medicines',
          'Knowledge',
          'Ask & Chat'
        ];
        menuNews = "News";
        language = "en";
        dynSize = 16.0;
        newsList.clear();
        _isLoading = false;
        _getNews();
      });
    }
  }

  Future<bool> _exitApp() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Are you sure to exit the app?",
              style: TextStyle(color: Color(0xFF000000)),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                  onPressed: () => exit(0)),
              FlatButton(
                  child: Text(
                    "No",
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                  onPressed: () => Navigator.of(context).pop(false)),
            ],
          ),
    );
  }

  _menuRoute(String name) {
    if (name == "Records Book" || name == "ဆေးမှတ်တမ်းစာအုပ်များ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: ProfileScreen(
            lan: language,
            authFunction: Authentic(),
          )));
    } else if (name == "Doctors" || name == "ဆရာဝန်များ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: DoctorTypeList(
            language: language,
            appbarTitle: name,
          )));
    } else if (name == 'Medicines' || name == "ဆေးဝါးများ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: MedicineList(
            language: language,
            appbarTitle: name,
          )));
    } else if (name == 'Knowledge' || name == "အသိပညာ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: KnowledgeMainPage(
            appbarTitle: name,
            language: language,
          )));
    } else if (name == 'Ask & Chat' || name == "အမေးအဖြေ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: ChatRoom(
            appbarTitle: name,
            language: language,
            authFunction: Authentic(),
          )));
    } else if (name == 'Hospitals' || name == "ဆေးရုံများ") {
      Navigator.push(
          context,
          SlideRightAnimation(
              widget: Hospital(
            language,
          )));
    } else {
      _showSnackBar();
    }
  }

  _showSnackBar() {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(
        "Unavailable!",
        style: TextStyle(fontSize: 16.0),
      ),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _menuListWidgets(List<String> items) {
    List<Widget> menuList = List<Widget>();
    for (var i = 0; i < menuName.length; i++) {
      menuList.add(
        Card(
            color: Color(0xFF72bb53),
            child: FlatButton(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                onPressed: () {
                  _menuRoute(menuName[i]);
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        menuIcon[i],
                        width: 28.0,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        menuName[i],
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: dynSize,
                            height: 0.75),
                      ),
                    )),
                  ],
                ))),
      );
    }
    return Column(
      children: menuList,
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return WillPopScope(
          onWillPop: _exitApp,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFF72bb53),
              centerTitle: true,
              title: Text(
                "OAAO Health Care",
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20.0),
              ),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: _languageChg,
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  itemBuilder: (BuildContext context) {
                    return MenuSetting.languages.map((String language) {
                      return PopupMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                            children: <Widget>[
                              Transform(
                                transform: Matrix4.translationValues(
                                    animation.value * deviceWidth, 0.0, 0.0),
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(114, 187, 83, 0.25),
                                        blurRadius: 10.0)
                                  ]),
                                  child: Card(
                                    elevation: 3.6,
                                    child: FlatButton(
                                      highlightColor:
                                          Color.fromRGBO(255, 255, 255, 0.5),
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            SlideRightAnimation(
                                                widget: ReminderList(
                                              language: language,
                                            )));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Image.asset(
                                              "assets/icons/noti_bell.png",
                                              width: 36.0,
                                            ),
                                            title: Text(
                                              reminderTitle.toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xFF666666),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              reminderShowDate,
                                              style: TextStyle(
                                                  color: Color(0xFF888888),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            trailing: Text(
                                              reminderTime,
                                              style: TextStyle(
                                                  color: Color(0xFF666666),
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Image.asset(
                                              "assets/icons/noti_appointment.png",
                                              width: 36.0,
                                            ),
                                            title: Text(
                                              appointTitle.toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xFF666666),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              appointShowDate,
                                              style: TextStyle(
                                                  color: Color(0xFF888888),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            trailing: Text(
                                              appointTime,
                                              style: TextStyle(
                                                  color: Color(0xFF666666),
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(16.0),
                                child: Row(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0,
                                          logoAnimation.value * deviceWidth,
                                          0.0),
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        width: (deviceWidth / 2) - 16,
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          menuAnimation.value * deviceWidth,
                                          0.0,
                                          0.0),
                                      child: Container(
                                        width: (deviceWidth / 2) - 16,
                                        child: _menuListWidgets(menuName),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  menuNews,
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Divider(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                              _isLoading == true
                                  ? CarouselSlider(
                                      distortion: false,
                                      items: newsList.map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  12.0, 8.0, 12.0, 8.0),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .title
                                                      .color,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            114, 187, 83, 0.5),
                                                        blurRadius: 10.0)
                                                  ]),
                                              child: FlatButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding: EdgeInsets.all(16.0),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      SlideFromBottomAnimation(
                                                          widget: NewsPage(
                                                        news: i,
                                                        language: language,
                                                        appbarTitle: menuNews,
                                                      )));
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerStart,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Text(
                                                                i.newsDate.substring(
                                                                    0,
                                                                    i.newsDate
                                                                        .indexOf(
                                                                            ' ')),
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .title
                                                                        .color),
                                                              ),
                                                              Text(
                                                                  i.newsDate.substring(
                                                                      3,
                                                                      i.newsDate
                                                                          .lastIndexOf(
                                                                              ' ')),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .title
                                                                          .color)),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.event_note,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 48.0,
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0,
                                                              bottom: 0.0),
                                                      child: Text(
                                                        i.newsTitle,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333333),
                                                            height: 1.25,
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                      height: 200.0,
                                      autoPlay: false)
                                  : Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Theme.of(context).primaryColor),
                                      ),
                                    )
                            ],
                          ),
                      childCount: 1),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
