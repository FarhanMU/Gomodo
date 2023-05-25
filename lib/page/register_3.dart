import 'dart:ffi';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class register_3 extends StatefulWidget {
  @override
  State<register_3> createState() => _register_3State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _register_3State extends State<register_3> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  bool validationPhoneNumber = false;

  void initState() {
    super.initState();
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
        color: whiteColor,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: Scaffold(
            body: SafeArea(
                child: Stack(children: [
          Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Center(
                    child: Container(
                      child: Image.asset(
                        "assets/images/Login/1.png",
                        width: 200,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Register Success!',
                          style: TextStyleMontserratW600Blue2_17,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Thank you for your submission. We will review your submission and send the result in the next few days through your registered contact!',
                          style: TextStyleMontserratW500Blue3_15,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => welcomeScreen_2()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: defaultBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      'Back',
                      style: TextStyleMontserratW600White_15,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )
        ]))));
  }
}
