import 'dart:ffi';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/api/api_getNotification.dart';
import 'package:gomodo_mobile/api/api_pushNotification.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/layout/menu_layout.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/productList_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../model/model_getNotification.dart';
import 'transactionList_2.dart';

class dashboard_2 extends StatefulWidget {
  @override
  State<dashboard_2> createState() => _dashboard_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _dashboard_2State extends State<dashboard_2> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final searchOrdersController = TextEditingController();

  String? categoriesItemSelectedValue;
  List<String> categoriesItem = ["satu", "dua", "tiga"];

  bool conditionLowToHigh = false;
  bool conditionHighToLow = false;
  bool conditionDateASC = false;
  bool conditionDateDESC = false;

  bool searchOrdersActive = true;
  bool loading = true;
  bool loadingNotif = true;
  int responsestatusCode = 0;
  List<String> allIdNotification = [];

  void api_pushNotificationfromApiAll(String notificationTypeId) async {
    api_pushNotification.pushNotification(notificationTypeId).then((response) {
      setState(() {
        EasyLoading.dismiss();
        // loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {}
      });
    });
  }

  void api_pushNotificationfromApi(String notificationTypeId, int index) async {
    api_pushNotification.pushNotification(notificationTypeId).then((response) {
      setState(() {
        EasyLoading.dismiss();
        // loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          if (getNotification[index].notificationTypeId.toString() == '1') {
            box.write("transactionId",
                getNotification[index].transactionId.toString());
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => transactionList_2()));
          } else if (getNotification[index].notificationTypeId.toString() ==
              '2') {
            box.write("transactionId",
                getNotification[index].transactionId.toString());
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => transactionList_2()));
          } else if (getNotification[index].notificationTypeId.toString() ==
              '3') {
            box.write("idProduct", getNotification[index].productId.toString());
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => productList_2()));
          }
        }
      });
    });
  }

  List<model_getNotification> getNotification = [];
  void getNotificationfromApi() async {
    api_getNotification.getNotification().then((response) {
      setState(() {
        loadingNotif = false;
        List<int> allCountNotification = [];
        allCountNotification.clear();

        for (int i = 0; i < response.length; i++) {
          allIdNotification.add(response[i]['notificationTypeId'].toString());
          if (response[i]['isRead'] == 1) {
            allCountNotification.add(i);
            // if (allCountNotification.length == response.length) {
            //   getNotification = [];
            //   return;
            // }
          }
        }

        Iterable list = response;
        getNotification =
            list.map((model) => model_getNotification.fromJson(model)).toList();
      });
    });
  }

  void initState() {
    getNotificationfromApi();
    super.initState();
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(context).size.shortestSide;

// Determine if we should use mobile layout or not, 600 here is
// a common breakpoint for a typical 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;

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
          Image.asset(
            'assets/images/Transaction/3.png',
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/Transaction/1.png",
                      width: 125,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Notifications',
                                          style:
                                              TextStyleMontserratW600Blue2_17,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            for (int i = 0;
                                                i < allIdNotification.length;
                                                i++) {
                                              api_pushNotificationfromApiAll(
                                                  allIdNotification[i]);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              'Mark all as read',
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: loadingNotif == false
                                          ? getNotification.length == 0
                                              ? Center(
                                                  child: Text(
                                                    "You have no new notification!",
                                                    style:
                                                        TextStyleMontserratW600Blue3_17,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : ListView.builder(
                                                  itemCount:
                                                      getNotification.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return InkWell(
                                                        onTap: () {
                                                          api_pushNotificationfromApi(
                                                              getNotification[
                                                                      index]
                                                                  .notificationTypeId
                                                                  .toString(),
                                                              index);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          decoration: BoxDecoration(
                                                              color: getNotification[
                                                                              index]
                                                                          .isRead ==
                                                                      0
                                                                  ? whiteDDDDDD
                                                                  : whiteColor,
                                                              border: Border.all(
                                                                  width: 0,
                                                                  color: getNotification[index]
                                                                              .isRead ==
                                                                          0
                                                                      ? blackColor
                                                                      : whiteD5DDE0)),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 3,
                                                          ),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 90,
                                                                  height: 90,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/Transaction/2.png',
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      child:
                                                                          Text(
                                                                        getNotification[index]
                                                                            .message,
                                                                        style:
                                                                            TextStyleMontserratW500Blue2_15,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      child:
                                                                          Text(
                                                                        getNotification[index]
                                                                            .createdAt
                                                                            .substring(0,
                                                                                10),
                                                                        style:
                                                                            TextStyleMontserratW500Gray_13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ]),
                                                        ),
                                                      );
                                                    });
                                                  })
                                          : ListView.builder(
                                              itemCount: 10,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 100,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: whiteDDDDDD,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                whiteD5DDE0)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                    child: Shimmer(
                                                      duration: Duration(
                                                          seconds:
                                                              3), //Default value
                                                      interval: Duration(
                                                          seconds:
                                                              1), //Default value: Duration(seconds: 0)
                                                      color: Colors
                                                          .white, //Default value
                                                      colorOpacity:
                                                          0.5, //Default value
                                                      enabled:
                                                          true, //Default value
                                                      direction:
                                                          ShimmerDirection
                                                              .fromLTRB(),
                                                      child: Container(),
                                                    ));
                                              }),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'View all notifications',
                                          style:
                                              TextStyleMontserratW500Blue3_13,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        "assets/images/Transaction/4.png",
                        width: 60,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome !',
                      style: TextStyleMontserratW500Blue3_17,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/Dashboard OPage/unlink.png',
                          width: 15,
                        ),
                        Text(
                          'Unlink',
                          style: TextStyleMontserratW500Blue3_13,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 0.8,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                              'assets/images/Dashboard OPage/bank.png')),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: grayAAB1B3)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/Dashboard OPage/wallet.png',
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'YOUR BALANCE',
                                  style: TextStyleMontserratW500Blue3_13,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Rp 1,120,000',
                              style: TextStyleMontserratW600Blue3_17,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '(last updated: 7 mins ago)',
                              style: TextStyleMontserratW500Gray_13,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Dashboard OPage/restart.png',
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Update',
                              style: TextStyleMontserratW500Blue2_15,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 0.8,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Highlights',
                            style: TextStyleMontserratW500Blue2_15,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '199',
                                style: TextStyleMontserratW600Blue2_24,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Link your bank account',
                                style: TextStyleMontserratW500Blue3_13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: grayAAB1B3)),
                          ),
                          Column(
                            children: [
                              Text(
                                '12',
                                style: TextStyleMontserratW600Blue2_24,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Unreceived Payment',
                                style: TextStyleMontserratW500Blue3_13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 0.8,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Business',
                                style: TextStyleMontserratW500Blue2_15,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Store data review',
                                style: TextStyleMontserratW500Blue3_13,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '(Last updated: 11:20 GMT+7)',
                                style: TextStyleMontserratW500Gray_13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "assets/images/Dashboard OPage/graphic.png",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: defaultBlueColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 0.8,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              'NEW FEATURES COMING SOON!',
                              style: TextStyleMontserratW600White_17,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              'We still working for something new please wait until it’s finally release',
                              style: TextStyleMontserratW500White_15,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/Dashboard OPage/graphic2.png",
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          menu_layout(context, "Home")
        ]))));
  }
}
