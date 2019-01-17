import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Models/knowledge/articles.dart';
import '../../Views/knowledge/knowledge_detail.dart';

class KnowledgeMainPage extends StatefulWidget {
  final String language;
  final String appbarTitle;
  KnowledgeMainPage({this.language, this.appbarTitle});
  @override
  _KnowledgeMainPageState createState() =>
      _KnowledgeMainPageState(appbarTitle: appbarTitle, language: language);
}

class _KnowledgeMainPageState extends State<KnowledgeMainPage> {
  final String language;
  final String appbarTitle;
  _KnowledgeMainPageState({this.language, this.appbarTitle});

  String careProcedure = 'Care Procedure';
  String emergencyProcedure = 'Emergency Procedure';
  String lifeStyle = 'Life Style';
  String articles = 'Health Articles';
  double sizeFont = 16.0;
  var _isLoading = true;
  var _empty = "";
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  List<Articles> articlesList, list = [];

  @override
  void initState() {
    super.initState();
    print(language);
    _setLanguage(language);
    _getArticles();
  }

  _getArticles() {
    dbRef.child('articles').child(language).once().then((DataSnapshot snap) {
      if (snap.value == Null) {
        setState(() {
          _empty = "No Articles";
        });
      } else {
        var ids = snap.value.keys;
        var data = snap.value;
        for (var id in ids) {
          var article = Articles(
            id: id,
            date: data[id]['date'],
            title: data[id]['title'],
            content: data[id]['content'],
            img: data[id]['img'],
          );
          list.add(article);
        }
        articlesList = list.reversed.toList();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  _setLanguage(String lang) {
    if (lang == 'mm') {
      setState(() {
        careProcedure = 'စောင့်ရှောက်မှု';
        emergencyProcedure = 'အရေးပေါ်ကုသမှု';
        lifeStyle = 'လူနေမှု';
        articles = 'ကျန်းမာရေးဆောင်းပါး';
        sizeFont = 14.0;
      });
    }
    if (lang == 'en') {
      setState(() {
        careProcedure = 'Care Procedure';
        emergencyProcedure = 'Emergency Procedure';
        lifeStyle = 'Life Style';
        articles = 'Health Articles';
        sizeFont = 16.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    var btnHeight = ((device.height - 24 - kToolbarHeight) / 4);
    var btnHeightLand = ((device.height - 24 - kToolbarHeight) / 2.5);
    var btnHeightLandxs = ((device.height - 24 - kToolbarHeight) / 2);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                appbarTitle,
                style:
                    TextStyle(color: Theme.of(context).textTheme.title.color),
              ),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Column(children: <Widget>[
                          SizedBox(
                            height: orientation == Orientation.landscape &&
                                    device.height > 600
                                ? btnHeightLand
                                : orientation == Orientation.landscape &&
                                        device.height < 600
                                    ? btnHeightLandxs
                                    : btnHeight,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: (device.width - 24) / 3,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    114, 187, 83, 0.5),
                                                blurRadius: 5.0)
                                          ],
                                          color: Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: FlatButton(
                                        highlightColor:
                                            Color.fromRGBO(255, 255, 255, 0.25),
                                        splashColor:
                                            Color.fromRGBO(0, 0, 0, 0.05),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text(
                                                careProcedure,
                                                style: TextStyle(
                                                    fontSize: sizeFont,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              height: orientation ==
                                                      Orientation.landscape
                                                  ? btnHeightLand / 2 - 14.0
                                                  : btnHeight / 2 - 36.0,
                                              width: (device.width - 24) / 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, bottom: 4.0),
                                                child: Image.asset(
                                                  'assets/icons/care_procedure.png',
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: (device.width - 24) / 3,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    114, 187, 83, 0.5),
                                                blurRadius: 5.0)
                                          ],
                                          color: Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: FlatButton(
                                        highlightColor:
                                            Color.fromRGBO(255, 255, 255, 0.25),
                                        splashColor:
                                            Color.fromRGBO(0, 0, 0, 0.05),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text(
                                                emergencyProcedure,
                                                style: TextStyle(
                                                    fontSize: sizeFont,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              height: orientation ==
                                                      Orientation.landscape
                                                  ? btnHeightLand / 2 - 14.0
                                                  : btnHeight / 2 - 36.0,
                                              width: (device.width - 24) / 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, bottom: 4.0),
                                                child: Image.asset(
                                                  'assets/icons/emergency_procedure.png',
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: (device.width - 24) / 3,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    114, 187, 83, 0.5),
                                                blurRadius: 5.0)
                                          ],
                                          color: Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: FlatButton(
                                        highlightColor:
                                            Color.fromRGBO(255, 255, 255, 0.25),
                                        splashColor:
                                            Color.fromRGBO(0, 0, 0, 0.05),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text(
                                                lifeStyle,
                                                style: TextStyle(
                                                    fontSize: sizeFont,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              height: orientation ==
                                                      Orientation.landscape
                                                  ? btnHeightLand / 2 - 14.0
                                                  : btnHeight / 2 - 36.0,
                                              width: (device.width - 24) / 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, bottom: 4.0),
                                                child: Image.asset(
                                                  'assets/icons/life_style.png',
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(12.0),
                            child: Text(
                              articles,
                              style: TextStyle(
                                  fontSize: orientation == Orientation.landscape
                                      ? 18.0
                                      : 24.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          _isLoading == false
                              ? SizedBox(
                                  height: orientation == Orientation.landscape
                                      ? device.height - btnHeight - 50.0
                                      : device.height - btnHeight + 16.0,
                                  child: ListView.builder(
                                    itemCount: articlesList.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        width: device.width,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    114, 187, 83, 0.25),
                                                blurRadius: 3)
                                          ],
                                        ),
                                        margin: EdgeInsets.fromLTRB(
                                            12.0, 4.0, 12.0, 4.0),
                                        child: FlatButton(
                                          highlightColor: Color.fromRGBO(
                                              255, 255, 255, 0.25),
                                          splashColor:
                                              Color.fromRGBO(0, 0, 0, 0.05),
                                          color: Theme.of(context)
                                              .textTheme
                                              .title
                                              .color,
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ArticlesDetail(
                                                          article:
                                                              articlesList[i],
                                                          language: language,
                                                        )));
                                          },
                                          child: SizedBox(
                                            height: 110.0,
                                            child: Row(
                                              children: <Widget>[
                                                ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10.0)),
                                                    child: Image.network(
                                                      articlesList[i].img,
                                                      fit: BoxFit.cover,
                                                      width: 110,
                                                      height: 110,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 12.0, top: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        articlesList[i].date,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF666666)),
                                                      ),
                                                      Container(
                                                        width:
                                                            device.width - 150,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 6.0,
                                                                right: 6.0),
                                                        child: Text(
                                                          articlesList[i].title,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          maxLines:
                                                              language == 'mm'
                                                                  ? 1
                                                                  : 2,
                                                          style: TextStyle(
                                                              height: 1.15,
                                                              fontSize:
                                                                  device.height <
                                                                          600
                                                                      ? 14.0
                                                                      : 16.0,
                                                              color: Color(
                                                                  0xFF333333)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : _empty.length <= 0
                                  ? Container(
                                      child: Text(_empty),
                                    )
                                  : Container(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    )
                        ]),
                    childCount: 1,
                  ),
                )
              ],
            ));
      },
    );
  }
}
