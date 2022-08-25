import 'dart:convert';
import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/editprofile.dart';
import 'package:chatinunii/screens/messages/messages_screen.dart';
import 'package:chatinunii/screens/settings/settings.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:chatinunii/screens/uploadphoto.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../authScreens/login.dart';
import '../components/bottomnavbar.dart';
import '../constants.dart';

class Profile extends StatefulWidget {
  String? username;
  Profile({Key? key, this.username}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

var data;

class _ProfileState extends State<Profile> {
  @override
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.toLanguageTag();
    });
    print('my locale ${myLocale.toLanguageTag()}');
    super.didChangeDependencies();
  }

  final translator = GoogleTranslator();
  var editProfile, sendMsg, uploadpic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    translator
        .translate("Send Message", from: 'en', to: '${lang!.split('-')[0]}')
        .then((value) {
      setState(() {
        editProfile = value;
      });
    });
    translator
        .translate("Edit Profile", from: 'en', to: '${lang!.split('-')[0]}')
        .then((value) {
      setState(() {
        editProfile = value;
      });
    });
    translator
        .translate("Upload\nPicture", from: 'en', to: '${lang!.split('-')[0]}')
        .then((value) {
      setState(() {
        uploadpic = value;
      });
    });

    widget.username == null
        ? Apis().getProfile().then((value) {
            print(value);
            if (value == 'Bad Response') {
              showToast('Error! Can\'t Get User profile');
            } else {
              setState(() {
                data = jsonDecode(value)["Response"]['Records'][0];
              });
              for (var i = 0;
                  i <
                      jsonDecode(value)["Response"]['Records'][0]
                              ['ProfilePhotos']
                          .length;
                  i++) {
                if (jsonDecode(value)["Response"]['Records'][0]['ProfilePhotos']
                        [i]['MainPhoto'] ==
                    1) {
                  setState(() {
                    mainPhoto = jsonDecode(value)["Response"]['Records'][0]
                        ['ProfilePhotos'][i]['FileURL'];
                  });
                  break;
                }
              }
            }
          })
        : Apis().getUserProfile(widget.username!).then((value) {
            print(value);
            if (value == 'Bad Response') {
              showToast('Error! Can\'t Get User profile');
            } else {
              setState(() {
                data = jsonDecode(value)["Response"];
              });
              for (var i = 0;
                  i < jsonDecode(value)["Response"]['ProfilePhotos'].length;
                  i++) {
                if (jsonDecode(value)["Response"]['ProfilePhotos'][i]
                        ['MainPhoto'] ==
                    1) {
                  setState(() {
                    mainPhoto = jsonDecode(value)["Response"]['ProfilePhotos']
                        [i]['FileURL'];
                  });
                  break;
                }
              }
            }
          });
  }

  String mainPhoto = 'abcd';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(text: "$profile"),
      body: (data == null || uploadpic == null)
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(mainPhoto),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data['UserName'],
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 16),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          data['UserName'] == usernamecontroller.text.trim()
                              ? Text(data['Email'],
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 16))
                              : Text(""),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var msgdata;
                      widget.username == null
                          ? null
                          : print("socket ${socket.connected}");
                      var p = {
                        'Message':
                            '', // the message must be send empty string as like “”,
                        'ToUserName':
                            widget.username, // user profile name / UserName,
                        'Lang': lang!, //-phone language,
                        'Token': token!
                      };
                      socket.emit("CreateChat", p);
                      print('done');
                      Apis().GetchatScreenList().then((value) {
                        if (value == 'Bad Request') {
                          showToast('Error in getting messages');
                        } else {
                          int index = 0;
                          for (var i = 0;
                              i <
                                  jsonDecode(value)['Response']['Records']
                                      .length;
                              i++) {
                            if (widget.username ==
                                jsonDecode(value)['Response']['Records'][i]
                                    ['ChatCreatedUserName']) {
                              index = i;
                              break;
                            }
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => widget.username == null
                                  ? const EditProfile()
                                  : MessagesScreen(
                                      username: widget.username,
                                      data: jsonDecode(value)['Response']
                                          ['Records'][index],
                                      index: index,
                                    )));
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          gradient: const LinearGradient(
                              colors: [Colors.white, Colors.white]),
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: 200,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          widget.username == null ? '$editProfile' : '$sendMsg',
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.566,
                    child: data['ProfilePhotos'] == null
                        ? Center(
                            child: Text('No Photos Found'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: data['ProfilePhotos'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: (context),
                                        builder: (context) => showDetails(
                                            data['ProfilePhotos'][index]
                                                ['FileURL'],
                                            data['ProfilePhotos'][index]
                                                ['FileId']));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data['ProfilePhotos'][index]
                                                    ['FileURL']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
      floatingActionButton: widget.username != null
          ? null
          : FloatingActionButton(
              onPressed: () {
                bool flag = false;
                if (data['ProfilePhotos'] == null) {
                  flag = true;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UploadPhoto(
                          flag: flag,
                        )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo),
                  FittedBox(
                      child: Text(
                    '$uploadpic',
                    style: TextStyle(fontSize: 9.5),
                  ))
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (int index) => btn(index, context),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.messenger,
            ),
            label: "$chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "$people",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "$profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "$settings",
          ),
        ],
      ),
    );
  }

  String? localmage;

  Widget showDetails(String img, String field) {
    return AlertDialog(
        title: Image(image: NetworkImage(img)),
        content: usernamecontroller.text.trim() != data['UserName']
            ? SizedBox()
            : FittedBox(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Apis().deletePhoto(field).then((value) {
                          if (value == 'Bad Response') {
                            showToast(
                                'Error! can\'t delete photo at the moment');
                          } else {
                            showToast('Photo has been deleted');
                            Navigator.pop(context);
                            setState(() {});
                          }
                        });
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete,
                            color: kPrimaryColor,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(color: kPrimaryColor),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    InkWell(
                      onTap: () {
                        Apis().setProfileImage(field).then((value) {
                          if (value == 'Bad Response') {
                            showToast('Error! can\'t set profile photo');
                          } else {
                            showToast('Profile photo is set');
                            Navigator.pop(context);
                            setState(() {});
                          }
                        });
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.person, color: kPrimaryColor),
                          Text('Set as main photo',
                              style: TextStyle(color: kPrimaryColor))
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }
}

btn(i, context) {
  if (i == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ChatsScreen()));
  } else if (i == 1) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatByStatus(
                  flag: true,
                )));
  } else if (i == 2) {
  } else {
    if (loginFlag == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}

AppBar buildAppBar({required String text}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: kPrimaryColor,
    title: Text(
      text,
    ),
  );
}
