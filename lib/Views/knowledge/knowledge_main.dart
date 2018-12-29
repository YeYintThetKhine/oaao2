import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _setLanguage(language);
  }

  _setLanguage(String lang) {
    if (lang == 'mm') {
      setState(() {
        careProcedure = 'စောင့်ရှောက်မှုလုပ်ထုံးလုပ်နည်း';
        emergencyProcedure = 'အရေးပေါ်လုပ်ထုံးလုပ်နည်း';
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
                            height: orientation == Orientation.landscape
                                ? btnHeightLand
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
                          SizedBox(
                            height: orientation == Orientation.landscape
                                ? device.height - btnHeight - 50.0
                                : device.height - btnHeight + 16.0,
                            child: ListView.builder(
                              itemCount: 101,
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
                                  margin:
                                      EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
                                  child: FlatButton(
                                    highlightColor:
                                        Color.fromRGBO(255, 255, 255, 0.25),
                                    splashColor: Color.fromRGBO(0, 0, 0, 0.05),
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                    padding: EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    onPressed: () {},
                                    child: SizedBox(
                                      height: 110.0,
                                      child: Row(
                                        children: <Widget>[
                                          ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  topLeft:
                                                      Radius.circular(10.0)),
                                              child: Image.asset(
                                                'assets/images/image.jpg',
                                              )),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 8.0, top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "11/12/2018",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16.0),
                                                  child: Text(
                                                    "Article Heading $i"
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            device.height < 600
                                                                ? 16.0
                                                                : 20.0,
                                                        color: Theme.of(context)
                                                            .primaryColor),
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
