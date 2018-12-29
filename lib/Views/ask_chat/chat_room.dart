import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String language;
  final String appbarTitle;
  ChatRoom({this.appbarTitle, this.language});
  @override
  _ChatRoomState createState() =>
      _ChatRoomState(appbarTitle: appbarTitle, language: language);
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  final String language;
  final String appbarTitle;
  _ChatRoomState({this.appbarTitle, this.language});

  final List<ChatMessagesArea> _messages = <ChatMessagesArea>[];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isEmpty = false;

  @override
  void dispose() {
    for (ChatMessagesArea messagesArea in _messages) {
      messagesArea.animationController.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isEmpty = false;
    });
    ChatMessagesArea message = new ChatMessagesArea(
      message: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _textSender() {
    return new Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                onChanged: (String msg) {
                  setState(() {
                    _isEmpty = msg.length > 0;
                  });
                },
                decoration: InputDecoration.collapsed(
                    hintText: language == 'mm'
                        ? "မက်ဆေ့ချ်ပို့ရန်"
                        : "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: _isEmpty == true
                      ? Theme.of(context).primaryColor
                      : Color(0xFF888888),
                ),
                onPressed: _isEmpty == true
                    ? () => _handleSubmitted(_textEditingController.text)
                    : null,
              ),
            )
          ],
        ));
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
            ),
            body: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                Divider(
                  height: 1.0,
                ),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _textSender(),
                )
              ],
            ));
      },
    );
  }
}

class ChatMessagesArea extends StatelessWidget {
  final String message;
  final AnimationController animationController;
  ChatMessagesArea({this.message, this.animationController});

  final String _name = "User";

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).textTheme.title.color,
                  )),
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0, right: 12.0),
                    child: new Text(message),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
