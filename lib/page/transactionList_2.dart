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
import 'package:gomodo_mobile/api/api_getTransactionDetail.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/register_3.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class transactionList_2 extends StatefulWidget {
  @override
  State<transactionList_2> createState() => _transactionList_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _transactionList_2State extends State<transactionList_2> {
  GetStorage box = GetStorage();

  RefreshController refreshController = RefreshController();
  bool loading = true;

  void delayGetData() async {
    await Future.delayed(Duration(seconds: 5));
    getDetailTransactionfromApi();
  }

  String orderId = "";
  String createdAt = "";
  String customer = "";
  String customerPhone = "";
  String customerEmail = "";
  String productName = "";
  String productCurrency = "";
  String productImage = "";
  String priceAmount = "";
  String quantity = "";
  String status = "";
  String totalPrice = "";
  List<dynamic> payment = [];
  String specialNotes = "";

  void getDetailTransactionfromApi() async {
    String idTransaction = box.read("transactionId");

    api_getTransactionDetail
        .getTransactionDetail(idTransaction)
        .then((response) {
      setState(() {
        orderId = response.orderDetail[0]["orderId"].toString();
        // print("asuiuuuu");
        // print(orderId);
        createdAt = response.orderDetail[0]["createdAt"].toString();
        customer = response.customer["customerName"].toString();
        customerPhone = response.customer["customerPhone"].toString();
        customerEmail = response.customer["customerEmail"].toString();
        productName = response.product["productName"].toString();

        productCurrency = response.product["productCurrency"].toString();
        priceAmount = response.orderDetail[0]["priceAmount"].toString();
        totalPrice = response.orderDetail[0]["totalPrice"].toString();

        productImage = response.product["productImage"].toString();

        quantity = response.orderDetail[0]["quantity"].toString();
        status = response.status.toString();
        specialNotes = response.specialNotes.toString();
        payment = response.payment;
        loading = false;
      });
    });
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getDetailTransactionfromApi();
    setState(() {});
    refreshController.refreshCompleted();
  }

  void initState() {
    getDetailTransactionfromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
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
          SmartRefresher(
            controller: refreshController,
            onRefresh: onRefresh,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: header_layout("Transaction History")),
                        SizedBox(
                          height: 20,
                        ),
                        loading == false
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                        color: whiteD5DDE0, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Order ID',
                                              style:
                                                  TextStyleMontserratW600Blue2_15,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '$orderId',
                                              style:
                                                  TextStyleMontserratBoldBlue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Order created at ' +
                                                  createdAt
                                                      .toString()
                                                      .substring(0, 10),
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteDDDDDD,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: blackColor, width: 1)),
                                child: Shimmer(
                                  duration:
                                      Duration(seconds: 3), //Default value
                                  interval: Duration(
                                      seconds:
                                          1), //Default value: Duration(seconds: 0)
                                  color: Colors.white, //Default value
                                  colorOpacity: 0.5, //Default value
                                  enabled: true, //Default value
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(),
                                )),
                        SizedBox(
                          height: 20,
                        ),
                        loading == false
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                        color: whiteD5DDE0, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Customer',
                                              style:
                                                  TextStyleMontserratW600Blue2_15,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '$customer',
                                              style:
                                                  TextStyleMontserratBoldBlue3_15,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/Transaction/10.png',
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '$customerPhone',
                                                  style:
                                                      TextStyleMontserratW500Blue2_13,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/Transaction/11.png',
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '$customerEmail',
                                                  style:
                                                      TextStyleMontserratW500Blue2_13,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteDDDDDD,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: blackColor, width: 1)),
                                child: Shimmer(
                                  duration:
                                      Duration(seconds: 3), //Default value
                                  interval: Duration(
                                      seconds:
                                          1), //Default value: Duration(seconds: 0)
                                  color: Colors.white, //Default value
                                  colorOpacity: 0.5, //Default value
                                  enabled: true, //Default value
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(),
                                )),
                        SizedBox(
                          height: 20,
                        ),
                        loading == false
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                        color: whiteD5DDE0, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: status.toString() == "UNPAID"
                                                ? grayAAB1B3
                                                : status.toString() ==
                                                        "RESELLER PAID"
                                                    ? grayAAB1B3
                                                    : status.toString() ==
                                                            "MERCHANT RECEIVED"
                                                        ? green28B710
                                                        : status.toString() ==
                                                                "CANCELED"
                                                            ? card_sunday
                                                            : card_sunday,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            )),
                                        child: Text(
                                          status.toString() == "UNPAID"
                                              ? "Unpaid"
                                              : status.toString() ==
                                                      "RESELLER PAID"
                                                  ? "Unpaid"
                                                  : status.toString() ==
                                                          "MERCHANT RECEIVED"
                                                      ? "Paid"
                                                      : status.toString() ==
                                                              "CANCELED"
                                                          ? "Paid"
                                                          : '-',
                                          style:
                                              TextStyleMontserratW600White_15,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Product',
                                              style:
                                                  TextStyleMontserratW600Blue3_15,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              child: Image.network(
                                                '$productImage',
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Container(
                                                    height: 90,
                                                    child: Image.asset(
                                                      'assets/images/default_empty.jpg',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  );
                                                },
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Mt. Bromo Sunrise Trip',
                                                  style:
                                                      TextStyleMontserratW600Blue2_15,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Price',
                                                  style:
                                                      TextStyleMontserratBoldBlue3_13,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  productCurrency +
                                                      ' ' +
                                                      fmf
                                                          .copyWith(
                                                            amount: double.parse(
                                                                priceAmount),
                                                          )
                                                          .output
                                                          .withoutFractionDigits,
                                                  style:
                                                      TextStyleMontserratW600Blue2_13,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'x $quantity',
                                                  style:
                                                      TextStyleMontserratW600Blue3_13,
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
                                          height: 2,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: whiteD5DDE0)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Payment',
                                                  style:
                                                      TextStyleMontserratBoldBlue3_15,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productCurrency +
                                                      ' ' +
                                                      fmf
                                                          .copyWith(
                                                            amount:
                                                                double.parse(
                                                                    totalPrice),
                                                          )
                                                          .output
                                                          .withoutFractionDigits,
                                                  style:
                                                      TextStyleMontserratW600Blue2_15,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Payment Created : -",
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              status == "UNPAID"
                                                  ? "Payment status: Unpaid"
                                                  : status ==
                                                          "MERCHANT RECEIVED"
                                                      ? "Payment status: Paid"
                                                      : status == "CANCELED"
                                                          ? "Payment status: Canceled"
                                                          : "Payment status: Paid",
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bank: -',
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bank Account No : -',
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bank Account Name : -',
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteDDDDDD,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: blackColor, width: 1)),
                                child: Shimmer(
                                  duration:
                                      Duration(seconds: 3), //Default value
                                  interval: Duration(
                                      seconds:
                                          1), //Default value: Duration(seconds: 0)
                                  color: Colors.white, //Default value
                                  colorOpacity: 0.5, //Default value
                                  enabled: true, //Default value
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(),
                                )),
                        SizedBox(
                          height: 10,
                        ),
                        loading == false
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                        color: whiteD5DDE0, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Special Notes',
                                              style:
                                                  TextStyleMontserratW600Blue2_15,
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              specialNotes == ''
                                                  ? '-'
                                                  : specialNotes,
                                              style:
                                                  TextStyleMontserratW500Blue3_13,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteDDDDDD,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: blackColor, width: 1)),
                                child: Shimmer(
                                  duration:
                                      Duration(seconds: 3), //Default value
                                  interval: Duration(
                                      seconds:
                                          1), //Default value: Duration(seconds: 0)
                                  color: Colors.white, //Default value
                                  colorOpacity: 0.5, //Default value
                                  enabled: true, //Default value
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(),
                                )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          )
        ]))));
  }
}
