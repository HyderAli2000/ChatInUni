import 'dart:async';
import 'dart:convert';
import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:flutter/material.dart';
import '../../../authScreens/login.dart';
import '../../../constants.dart';
import '../../../models/ChatMessage.dart';
import '../../splashscreen.dart';
import 'message.dart';

class Body extends StatefulWidget {
  // final messagelist;
  final username;
  var data;
  int index;
  bool transFlag;
  Body(
      {Key? key,
      required this.username,
      required this.data,
      required this.index,
      required this.transFlag})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

String? langCode;

class _BodyState extends State<Body> {
  @override
  var msgList;
  Timer? timer;

  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data['ChatId']);
    socket.on('Message', (data) => print(data));
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      getMsgs();
    });
  }

  getMsgs() {
    widget.transFlag == false
        ? Apis().GetchatScreenList().then((value) {
            setState(() {
              msgList = jsonDecode(value)['Response']['Records'][widget.index]
                  ['Messages'];
            });
          })
        : Apis()
            .TranslateChat(
                widget.data['ChatId'], langCode == null ? lang : langCode)
            .then((value) {
            setState(() {
              msgList = jsonDecode(value)['Response']['Messages'];
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
        ),
        child: SingleChildScrollView(
          reverse: true,
          child: msgList == null
              ? Center(child: CircularProgressIndicator())
              : msgList.length == 0
                  ? Center(child: Text('Empty Chat'))
                  : ListView.builder(
                      // reverse: true,.
                      // scrollDirection: Axis.ve9rtical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        return Message(
                          message: ChatMessage(
                              text: msgList[index]['Message'],
                              messageType: ChatMessageType.text,
                              messageStatus: MessageStatus.viewed,
                              isSender: msgList[index]['ToUserName'] ==
                                      widget.username
                                  ? true
                                  : false),
                          image: widget.data['ProfilePhotos'] == null
                              ? ''
                              : widget.data['ProfilePhotos'][0]['FileURL'],
                        );
                      }),
        ),
      ),
    );
  }
}
