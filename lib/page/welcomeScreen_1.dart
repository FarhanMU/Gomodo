import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/page/productList_1.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class welcomeScreen_1 extends StatefulWidget {
  @override
  State<welcomeScreen_1> createState() => _welcomeScreen_1State();
}

class _welcomeScreen_1State extends State<welcomeScreen_1> {
  GetStorage box = GetStorage();

  void changeScene() async {
    // Go to Page2 after 5s.
    Timer(Duration(seconds: 5), () {
      if (box.read("access_token") != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => productList_1()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => welcomeScreen_2()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    changeScene();
    // if (box.read("username") != null && box.read("pantryId") != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => display()));
    //   });
    // } else if (box.read("username") != null && box.read("pantryId") == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => listPantry()));
    //   });
    // }
    super.initState();
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        backgroundColor: defaultBlueColor,
        body: SafeArea(
            child: Stack(children: [
          Center(
            child: Container(
                child: Image.asset(
              "assets/images/Welcome/4.png",
              width: 150,
            )),
          )
        ])));
  }
}
