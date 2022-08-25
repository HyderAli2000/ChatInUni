// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:typed_data';
import 'package:chatinunii/components/bottomnavbar.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangePassword> {
  String localmage = '';
  TextEditingController oldpass = TextEditingController();
  TextEditingController newpass = TextEditingController();
  // TextEditingController image = TextEditingController();
  bool showPassword = false;
  String? lang;
  StatusModel? status;
  var data;
  @override
  Future<void> didChangeDependencies() async {
    Locale myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.toLanguageTag();
    });
    print('my locale ${myLocale.toLanguageTag()}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  buildTextField(
                      'Current Password',
                      Icon(
                        Icons.password,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                      oldpass),
                  SizedBox(
                    height: 25,
                  ),
                  buildTextField(
                      'New Password',
                      Icon(
                        Icons.password,
                        color: kPrimaryColor,
                      ),
                      newpass),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      Apis()
                          .changePassword(oldpass.text, newpass.text)
                          .then((value) {
                        if (value == 'Bad Request') {
                          showToast('Error! while Updating password');
                        } else {
                          showToast('Password has been Updated');
                        }
                      });
                    },
                    color: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: const Text(
        "Change Password",
      ),
    );
  }

  Widget buildTextField(
      String labelText, Icon icon, TextEditingController ctrl) {
    return Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: ctrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text(labelText),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
