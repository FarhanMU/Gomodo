import 'dart:ffi';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/register_1.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class welcomeScreen_2 extends StatefulWidget {
  @override
  State<welcomeScreen_2> createState() => _welcomeScreen_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _welcomeScreen_2State extends State<welcomeScreen_2> {
  GetStorage box = GetStorage();

  void initState() {
    super.initState();
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tekan Sekali Lagi Untuk Keluar');
      return Future.value(false);
    }

    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return WillPopScope(
      onWillPop: onWillPop,
      child: MaterialApp(
          color: whiteColor,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          home: Scaffold(
              body: SafeArea(
                  child: Stack(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      sliders(context),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login_1()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: defaultBlueColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Login',
                            style: TextStyleMontserratW600White_15,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => register_1()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Register',
                            style: TextStyleMontserratW600Blue2_15,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )))),
    );
  }
}

Widget sliders(BuildContext context) {
  final List listImage = [
    "assets/images/Welcome/1.png",
    "assets/images/Welcome/2.png",
    "assets/images/Welcome/3.png",
  ];

  final List listHeader = [
    "Welcome to Gomodo",
    "Welcome to Gomodo",
    "Welcome to Gomodo",
  ];

  final List listContent = [
    "Gomodo is a digital empowerment service platform for MSMEs (Micro, Small and Medium Enterprises) in the service and tourism sector",
    "Gomodo is a digital empowerment service platform for MSMEs (Micro, Small and Medium Enterprises) in the service and tourism sector",
    "Gomodo is a digital empowerment service platform for MSMEs (Micro, Small and Medium Enterprises) in the service and tourism sector",
  ];
  final List<Widget> imageSliders = listImage.asMap().entries.map((entry) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      listImage[entry.key],
                      fit: BoxFit.fill,
                      width: 230,
                      height: 200,
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              listHeader[entry.key],
              style: TextStyleMontserratBoldBlue18,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              listContent[entry.key],
              style: TextStyleMontserratW500Blue3_15,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }).toList();

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              height: 360,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSliders = index;
                });
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageSliders.asMap().entries.map((entry) {
              return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: _currentSliders == entry.key
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.all(10),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: defaultBlueColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.all(10),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border.all(color: blackColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                        ));
            }).toList(),
          ),
        )
      ],
    );
  });
}
