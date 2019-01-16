import 'package:flutter/material.dart';
import '../../Models/landing_page/news.dart';

class NewsPage extends StatefulWidget {
  final News news;
  final String language;
  final String appbarTitle;
  NewsPage({this.news, this.language, this.appbarTitle});
  @override
  _NewsPageState createState() =>
      _NewsPageState(news: news, language: language, appbarTitle: appbarTitle);
}

class _NewsPageState extends State<NewsPage> {
  News news;
  final String language;
  final String appbarTitle;
  _NewsPageState({this.news, this.language, this.appbarTitle});
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            appbarTitle,
            style: TextStyle(color: Theme.of(context).textTheme.title.color),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            height: (device.height - 24 - kToolbarHeight) / 5,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  width: (device.width - 16.0) / 3,
                                  child: Image.network(
                                    news.newsImg,
                                    fit: BoxFit.cover,
                                    height: 300.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Container(
                                  width: (device.width - 16.0) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: ((device.height -
                                                      24 -
                                                      kToolbarHeight) /
                                                  5) /
                                              2,
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 6.0),
                                          child: Text(
                                            news.newsTitle.toUpperCase(),
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF333333)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        padding: const EdgeInsets.only(
                                            left: 12.0, bottom: 6.0),
                                        child: Text(
                                          news.date,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF888888)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Divider(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 12.0),
                            child: Text(
                              news.newsContent,
                              style: TextStyle(height: 1.5, fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                  childCount: 1),
            )
          ],
        ),
      );
    });
  }
}
