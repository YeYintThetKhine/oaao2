import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  final String newsId;
  final String newsDate;
  final String language;
  final String appbarTitle;
  NewsPage({this.newsId, this.newsDate, this.language, this.appbarTitle});
  @override
  _NewsPageState createState() => _NewsPageState(
      newsId: newsId,
      newsDate: newsDate,
      language: language,
      appbarTitle: appbarTitle);
}

class _NewsPageState extends State<NewsPage> {
  final String newsId;
  final String newsDate;
  final String language;
  final String appbarTitle;
  _NewsPageState({this.newsId, this.newsDate, this.language, this.appbarTitle});
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
                                  width: (device.width - 16.0) / 3,
                                  child: Image.asset(
                                    "assets/images/image.jpg",
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
                                            newsId,
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        padding: const EdgeInsets.only(
                                            left: 12.0, bottom: 6.0),
                                        child: Text(
                                          "$newsDate/12/2018",
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
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
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
