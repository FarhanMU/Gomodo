import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/api/api_getNotification.dart';
import 'package:gomodo_mobile/api/api_getTransaction.dart';
import 'package:gomodo_mobile/api/api_eksporTransaction.dart';
import 'package:gomodo_mobile/api/api_pushNotification.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/layout/menu_layout.dart';
import 'package:gomodo_mobile/model/model_getTransaction.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/transactionList_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../layout/baseUrl.dart';
import '../model/model_getNotification.dart';
import 'productList_2.dart';

class transactionList_1 extends StatefulWidget {
  @override
  State<transactionList_1> createState() => _transactionList_1State();
}

final ReceivePort _port = ReceivePort();
int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _transactionList_1State extends State<transactionList_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final searchOrdersController = TextEditingController();

  String categoriesItemSelectedValue = "UNPAID";
  List<String> categoriesItem = ["UNPAID", "PAID", "CANCELED"];
  // List<String> categoriesItem = ["UNPAID", "RESELLER PAID", "CANCELED"];
  RefreshController refreshController = RefreshController();

  String sortOrder = "desc";
  String sortField = "createdAt";

  String _sortOrder = "desc";
  String _sortField = "createdAt";
  String keyword = "";

  bool conditionLowToHigh = false;
  bool conditionHighToLow = false;
  bool conditionDateASC = false;
  bool conditionDateDESC = true;

  bool searchOrdersActive = true;
  bool loading = true;
  bool loadingNotif = true;
  bool loading2 = false;
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

  List<model_getTransaction> getTransaction = [];
  void getTransactionfromApi(String _sortOrder) async {
    if (sortOrder == "conditionHighToLow") {
      _sortOrder = "desc";
      _sortField = "totalPrice";
    } else if (sortOrder == "conditionLowToHigh") {
      _sortOrder = "asc";
      _sortField = "totalPrice";
    } else if (sortOrder == "asc") {
      _sortOrder = "asc";
      _sortField = "createdAt";
    } else if (sortOrder == "desc") {
      _sortOrder = "desc";
      _sortField = "createdAt";
    }

    keyword = searchOrdersController.text;

    api_getTransaction
        .getTransaction("sortOrder=$_sortOrder", "&sortField=$_sortField",
            "&keyword=$keyword")
        .then((response) {
      setState(() {
        loading = false;

        List<int> allCountTransaction = [];
        allCountTransaction.clear();

        for (int i = 0; i < response.length; i++) {
          if (categoriesItemSelectedValue == "UNPAID") {
            if (response[i]['status'].toString() == "UNPAID" ||
                response[i]['status'].toString() == "RESELLER PAID") {
              allCountTransaction.add(i);
              // print('adeww');
              // print(allCountTransaction.length);
              if (allCountTransaction.length == response.length) {
                getTransaction = [];
                return;
              }
            }
          } else if (categoriesItemSelectedValue == "PAID") {
            if (response[i]['status'].toString() == "MERCHANT RECEIVED") {
              allCountTransaction.add(i);
              // print('adeww');
              // print(allCountTransaction.length);
              if (allCountTransaction.length == response.length) {
                getTransaction = [];
                return;
              }
            }
          } else if (categoriesItemSelectedValue == "CANCELED") {
            if (response[i]['status'].toString() != "CANCELED") {
              allCountTransaction.add(i);
              // print('adeww');
              // print(allCountTransaction.length);
              if (allCountTransaction.length == response.length) {
                getTransaction = [];
                return;
              }
            }
          }
        }

        Iterable list = response;
        getTransaction =
            list.map((model) => model_getTransaction.fromJson(model)).toList();
      });
    });
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getTransactionfromApi(_sortOrder);
    getNotificationfromApi();

    setState(() {});
    refreshController.refreshCompleted();
  }

  void eksporTransactionfromApi(String savePath) async {
    api_eksporTransaction.eksporTransaction().then((response) {
      EasyLoading.dismiss();
      setState(() {
        loading2 = false;
      });
      DownloadFile(savePath, response.url);
    });
  }

  void DownloadFile(String path, String url) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: path,
      headers: {
        'Authorization': 'Bearer ' + box.read("access_token"),
      },
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  void initState() {
    // IsolateNameServer.registerPortWithName(
    //     _port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus status = data[1];
    //   int progress = data[2];
    //   setState(() {});
    // });

    FlutterDownloader.registerCallback(downloadCallback);

    getTransactionfromApi(_sortOrder);
    getNotificationfromApi();

    super.initState();
  }

  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
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
    MoneyFormatter fmf = MoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
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
          home: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                body: SafeArea(
                    child: Stack(children: [
              Image.asset(
                'assets/images/Transaction/3.png',
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
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
                                                    i <
                                                        allIdNotification
                                                            .length;
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: loadingNotif == false
                                              ? getNotification.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        "You have no new notification!",
                                                        style:
                                                            TextStyleMontserratW600Blue3_17,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: getNotification
                                                          .length,
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
                                                                      vertical:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color: getNotification[index]
                                                                              .isRead ==
                                                                          0
                                                                      ? whiteDDDDDD
                                                                      : whiteColor,
                                                                  border: Border.all(
                                                                      width: 0,
                                                                      color: getNotification[index].isRead ==
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
                                                                      height:
                                                                          90,
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/Transaction/2.png',
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.35,
                                                                          child:
                                                                              Text(
                                                                            getNotification[index].message,
                                                                            style:
                                                                                TextStyleMontserratW500Blue2_15,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.35,
                                                                          child:
                                                                              Text(
                                                                            getNotification[index].createdAt.substring(0,
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
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        height: 100,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        decoration: BoxDecoration(
                                                            color: whiteDDDDDD,
                                                            border: Border.all(
                                                                width: 1,
                                                                color:
                                                                    whiteD5DDE0)),
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction List',
                          style: TextStyleMontserratW600Blue3_17,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: searchOrdersController,
                            decoration: InputDecoration(
                              fillColor: whiteColor,
                              filled: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10),
                                ),
                                borderSide: new BorderSide(
                                  color: defaultBlueColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                              } else {}
                              return null;
                            },
                            onChanged: (text) {
                              getTransactionfromApi(_sortOrder);
                            },
                            onTap: () {
                              setState(() {
                                searchOrdersActive = false;
                              });
                            },
                            onEditingComplete: () {
                              if (searchOrdersController.text == '') {
                                setState(() {
                                  searchOrdersActive = true;
                                });
                              } else {
                                setState(() {
                                  searchOrdersActive = false;
                                });
                              }
                            },
                          ),
                          Visibility(
                            visible: searchOrdersActive,
                            child: Positioned(
                              left: 40,
                              top: 18,
                              child: IgnorePointer(
                                ignoring: true,
                                child: Text(
                                  'Search Orders',
                                  style: TextStyleMontserratW500whiteD5DDE0_15,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: searchOrdersActive,
                            child: Positioned(
                              left: 10,
                              top: 15,
                              child: IgnorePointer(
                                ignoring: true,
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.close_rounded,
                                                    size: 18,
                                                    color: defaultBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Filter by',
                                                    style:
                                                        TextStyleMontserratW500Blue2_15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            StatefulBuilder(
                                                builder: (context, setState) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Status',
                                                        style:
                                                            TextStyleMontserratW500Blue3_16,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: blackColor,
                                                              width: 1)),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton2(
                                                          isExpanded: true,
                                                          hint: Text(
                                                              'Select Status',
                                                              style:
                                                                  TextStyleMontserratW500Blue3_15),
                                                          items: categoriesItem
                                                              .map((item) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value: item,
                                                                    child: Text(
                                                                        item,
                                                                        style:
                                                                            TextStyleMontserratW500Blue3_15),
                                                                  ))
                                                              .toList(),
                                                          value:
                                                              categoriesItemSelectedValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              categoriesItemSelectedValue =
                                                                  value
                                                                      as String;

                                                              // box.write('pantryId',
                                                              //     categoriesItemSelectedValue);
                                                            });
                                                          },
                                                          buttonStyleData:
                                                              const ButtonStyleData(
                                                            height: 50,
                                                          ),
                                                          menuItemStyleData:
                                                              const MenuItemStyleData(
                                                            height: 50,
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      getTransactionfromApi(
                                                          _sortOrder);
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 15),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              defaultBlueColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Back',
                                                        style:
                                                            TextStyleMontserratW600White_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      print(
                                                          categoriesItemSelectedValue);
                                                      setState(() {
                                                        categoriesItemSelectedValue =
                                                            "UNPAID";
                                                      });
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 15),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Reset',
                                                        style:
                                                            TextStyleMontserratW600Blue2_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteF7F8F9,
                                    border: Border.all(
                                        width: 1, color: whiteD5DDE0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Transaction/6.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Filter',
                                      style: TextStyleMontserratW600Blue3_15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.close_rounded,
                                                      size: 18,
                                                      color: defaultBlueColor,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'Sort By',
                                                      style:
                                                          TextStyleMontserratW500Blue2_15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sortOrder =
                                                            "conditionLowToHigh";
                                                      });
                                                      getTransactionfromApi(
                                                          "conditionLowToHigh");
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: sortOrder !=
                                                                  "conditionLowToHigh"
                                                              ? whiteF7F8F9
                                                              : defaultBlueColor,
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  whiteD5DDE0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Price: Low to High',
                                                        style: sortOrder !=
                                                                "conditionLowToHigh"
                                                            ? TextStyleMontserratW600Blue3_15
                                                            : TextStyleMontserratW600White_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sortOrder =
                                                            "conditionHighToLow";
                                                      });
                                                      getTransactionfromApi(
                                                          "conditionHighToLow");
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: sortOrder !=
                                                                  "conditionHighToLow"
                                                              ? whiteF7F8F9
                                                              : defaultBlueColor,
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  whiteD5DDE0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Price: High to Low',
                                                        style: sortOrder !=
                                                                "conditionHighToLow"
                                                            ? TextStyleMontserratW600Blue3_15
                                                            : TextStyleMontserratW600White_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sortOrder = "asc";
                                                      });
                                                      getTransactionfromApi(
                                                          "asc");
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: sortOrder !=
                                                                  "asc"
                                                              ? whiteF7F8F9
                                                              : defaultBlueColor,
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  whiteD5DDE0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Created Date: Asc',
                                                        style: sortOrder !=
                                                                "asc"
                                                            ? TextStyleMontserratW600Blue3_15
                                                            : TextStyleMontserratW600White_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sortOrder = "desc";
                                                      });
                                                      getTransactionfromApi(
                                                          "desc");
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: sortOrder !=
                                                                  "desc"
                                                              ? whiteF7F8F9
                                                              : defaultBlueColor,
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  whiteD5DDE0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Text(
                                                        'Created Date: Desc',
                                                        style: sortOrder !=
                                                                "desc"
                                                            ? TextStyleMontserratW600Blue3_15
                                                            : TextStyleMontserratW600White_15,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: whiteF7F8F9,
                                    border: Border.all(
                                        width: 1, color: whiteD5DDE0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Transaction/7.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Sort',
                                      style: TextStyleMontserratW600Blue3_15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () async {
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.storage,
                                  //add more permission to request here.
                                ].request();
                                if (statuses[Permission.storage]!.isGranted) {
                                  var dir = await DownloadsPathProvider
                                      .downloadsDirectory;
                                  if (dir != null) {
                                    String savePath = dir!.path;
                                    setState(() {
                                      loading2 = true;
                                    });

                                    EasyLoading.show(status: 'loading...');

                                    eksporTransactionfromApi(savePath);
                                  }
                                } else {
                                  print("No permission to read and write.");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: defaultBlueColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: 15,
                                      color: whiteColor,
                                    ),
                                    // Text(
                                    //   'CSV',
                                    //   style: TextStyleMontserratW600White_15,
                                    //   textAlign: TextAlign.center,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    loading == false
                        ? Expanded(
                            child: getTransaction.length == 0
                                ? SmartRefresher(
                                    controller: refreshController,
                                    onRefresh: onRefresh,
                                    child: Center(
                                      child: Text(
                                        "No Transaction Found",
                                        style: TextStyleMontserratW600Blue3_17,
                                      ),
                                    ),
                                  )
                                : SmartRefresher(
                                    controller: refreshController,
                                    onRefresh: onRefresh,
                                    child: ListView.builder(
                                        itemCount: getTransaction.length,
                                        itemBuilder:
                                            (BuildContext context2, index) {
                                          return InkWell(
                                              onTap: () async {
                                                box.write(
                                                    "transactionId",
                                                    getTransaction[index]
                                                        .transactionId
                                                        .toString());
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            transactionList_2()));
                                              },
                                              child: categoriesItemSelectedValue ==
                                                      "UNPAID"
                                                  ? getTransaction[index]
                                                                  .status
                                                                  .toString() ==
                                                              "UNPAID" ||
                                                          getTransaction[index]
                                                                  .status
                                                                  .toString() ==
                                                              "RESELLER PAID"
                                                      ? Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              color: whiteColor,
                                                              border: Border.all(
                                                                  color:
                                                                      whiteD5DDE0,
                                                                  width: 1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                  decoration: BoxDecoration(
                                                                      color: getTransaction[index].status.toString() == "UNPAID"
                                                                          ? grayAAB1B3
                                                                          : getTransaction[index].status.toString() == "RESELLER PAID"
                                                                              ? grayAAB1B3
                                                                              : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                  ? green28B710
                                                                                  : getTransaction[index].status.toString() == "CANCELED"
                                                                                      ? card_sunday
                                                                                      : card_sunday,
                                                                      borderRadius: BorderRadius.only(
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                        topRight:
                                                                            Radius.circular(10),
                                                                      )),
                                                                  child: Text(
                                                                    getTransaction[index].status.toString() ==
                                                                            "UNPAID"
                                                                        ? "Unpaid"
                                                                        : getTransaction[index].status.toString() ==
                                                                                "RESELLER PAID"
                                                                            ? "Unpaid"
                                                                            : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                ? "Paid"
                                                                                : getTransaction[index].status.toString() == "CANCELED"
                                                                                    ? "Canceled"
                                                                                    : '-',
                                                                    style:
                                                                        TextStyleMontserratBoldWhite_13,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          // Image.asset(
                                                                          //   'assets/images/Transaction/8.png',
                                                                          //   width: 20,
                                                                          // ),
                                                                          // SizedBox(
                                                                          //   width: 5,
                                                                          // ),
                                                                          // Text(
                                                                          //   'Traveloka',
                                                                          //   style:
                                                                          //       TextStyleMontserratW600Blue3_15,
                                                                          //   textAlign: TextAlign.center,
                                                                          // ),
                                                                          // SizedBox(
                                                                          //   width: 5,
                                                                          // ),
                                                                          Text(
                                                                              getTransaction[index].orderDetail[0]["createdAt"].toString().substring(0, 10),
                                                                              style: TextStyleMontserratW500Blue3_13,
                                                                              textAlign: TextAlign.center,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(15)),
                                                                            child:
                                                                                Image.network(
                                                                              getTransaction[index].product["productImage"].toString(),
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/images/default_empty.jpg',
                                                                                  fit: BoxFit.fill,
                                                                                  width: 80,
                                                                                  height: 80,
                                                                                );
                                                                              },
                                                                              fit: BoxFit.fill,
                                                                              width: 80,
                                                                              height: 80,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getTransaction[index].product["productName"],
                                                                                style: TextStyleMontserratW600Blue2_15,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text(
                                                                                getTransaction[index].product["productCurrency"].toString() +
                                                                                    ' ' +
                                                                                    fmf
                                                                                        .copyWith(
                                                                                          amount: double.parse(getTransaction[index].orderDetail[0]["priceAmount"].toString()),
                                                                                        )
                                                                                        .output
                                                                                        .withoutFractionDigits,
                                                                                style: TextStyleMontserratBoldBlue3_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text(
                                                                                'Quantity : ' + getTransaction[index].orderDetail[0]["quantity"].toString(),
                                                                                style: TextStyleMontserratW500Blue3_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
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
                                                                                style: TextStyleMontserratBoldBlue3_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text(
                                                                                getTransaction[index].product["productCurrency"].toString() +
                                                                                    ' ' +
                                                                                    fmf
                                                                                        .copyWith(
                                                                                          amount: double.parse(getTransaction[index].orderDetail[0]["totalPrice"].toString()),
                                                                                        )
                                                                                        .output
                                                                                        .withoutFractionDigits,
                                                                                style: TextStyleMontserratW600Blue2_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                'Order ID',
                                                                                style: TextStyleMontserratBoldBlue3_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text(
                                                                                getTransaction[index].orderDetail[0]["orderId"].toString(),
                                                                                style: TextStyleMontserratW600Blue3_13,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                  : categoriesItemSelectedValue ==
                                                          "PAID"
                                                      ? getTransaction[index]
                                                                  .status
                                                                  .toString() ==
                                                              "MERCHANT RECEIVED"
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      whiteColor,
                                                                  border: Border.all(
                                                                      color:
                                                                          whiteD5DDE0,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    right: 0,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: getTransaction[index].status.toString() == "UNPAID"
                                                                              ? grayAAB1B3
                                                                              : getTransaction[index].status.toString() == "RESELLER PAID"
                                                                                  ? grayAAB1B3
                                                                                  : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                      ? green28B710
                                                                                      : getTransaction[index].status.toString() == "CANCELED"
                                                                                          ? card_sunday
                                                                                          : card_sunday,
                                                                          borderRadius: BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(10),
                                                                            topRight:
                                                                                Radius.circular(10),
                                                                          )),
                                                                      child:
                                                                          Text(
                                                                        getTransaction[index].status.toString() ==
                                                                                "UNPAID"
                                                                            ? "Unpaid"
                                                                            : getTransaction[index].status.toString() == "RESELLER PAID"
                                                                                ? "Unpaid"
                                                                                : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                    ? "Paid"
                                                                                    : getTransaction[index].status.toString() == "CANCELED"
                                                                                        ? "Canceled"
                                                                                        : '-',
                                                                        style:
                                                                            TextStyleMontserratBoldWhite_13,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              // Image.asset(
                                                                              //   'assets/images/Transaction/8.png',
                                                                              //   width: 20,
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   width: 5,
                                                                              // ),
                                                                              // Text(
                                                                              //   'Traveloka',
                                                                              //   style:
                                                                              //       TextStyleMontserratW600Blue3_15,
                                                                              //   textAlign: TextAlign.center,
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   width: 5,
                                                                              // ),
                                                                              Text(getTransaction[index].orderDetail[0]["createdAt"].toString().substring(0, 10), style: TextStyleMontserratW500Blue3_13, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                child: Image.network(
                                                                                  getTransaction[index].product["productImage"].toString(),
                                                                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                    return Image.asset(
                                                                                      'assets/images/default_empty.jpg',
                                                                                      fit: BoxFit.fill,
                                                                                      width: 80,
                                                                                      height: 80,
                                                                                    );
                                                                                  },
                                                                                  fit: BoxFit.fill,
                                                                                  width: 80,
                                                                                  height: 80,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getTransaction[index].product["productName"],
                                                                                    style: TextStyleMontserratW600Blue2_15,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    getTransaction[index].product["productCurrency"].toString() +
                                                                                        ' ' +
                                                                                        fmf
                                                                                            .copyWith(
                                                                                              amount: double.parse(getTransaction[index].orderDetail[0]["priceAmount"].toString()),
                                                                                            )
                                                                                            .output
                                                                                            .withoutFractionDigits,
                                                                                    style: TextStyleMontserratBoldBlue3_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    'Quantity : ' + getTransaction[index].orderDetail[0]["quantity"].toString(),
                                                                                    style: TextStyleMontserratW500Blue3_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'Total Payment',
                                                                                    style: TextStyleMontserratBoldBlue3_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    getTransaction[index].product["productCurrency"].toString() +
                                                                                        ' ' +
                                                                                        fmf
                                                                                            .copyWith(
                                                                                              amount: double.parse(getTransaction[index].orderDetail[0]["totalPrice"].toString()),
                                                                                            )
                                                                                            .output
                                                                                            .withoutFractionDigits,
                                                                                    style: TextStyleMontserratW600Blue2_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    'Order ID',
                                                                                    style: TextStyleMontserratBoldBlue3_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    getTransaction[index].orderDetail[0]["orderId"].toString(),
                                                                                    style: TextStyleMontserratW600Blue3_13,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container()
                                                      : categoriesItemSelectedValue ==
                                                              "CANCELED"
                                                          ? getTransaction[
                                                                          index]
                                                                      .status
                                                                      .toString() ==
                                                                  "CANCELED"
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          whiteColor,
                                                                      border: Border.all(
                                                                          color:
                                                                              whiteD5DDE0,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 10,
                                                                              vertical: 5),
                                                                          decoration: BoxDecoration(
                                                                              color: getTransaction[index].status.toString() == "UNPAID"
                                                                                  ? grayAAB1B3
                                                                                  : getTransaction[index].status.toString() == "RESELLER PAID"
                                                                                      ? grayAAB1B3
                                                                                      : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                          ? green28B710
                                                                                          : getTransaction[index].status.toString() == "CANCELED"
                                                                                              ? card_sunday
                                                                                              : card_sunday,
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(10),
                                                                                topRight: Radius.circular(10),
                                                                              )),
                                                                          child:
                                                                              Text(
                                                                            getTransaction[index].status.toString() == "UNPAID"
                                                                                ? "Unpaid"
                                                                                : getTransaction[index].status.toString() == "RESELLER PAID"
                                                                                    ? "Unpaid"
                                                                                    : getTransaction[index].status.toString() == "MERCHANT RECEIVED"
                                                                                        ? "Paid"
                                                                                        : getTransaction[index].status.toString() == "CANCELED"
                                                                                            ? "Canceled"
                                                                                            : '-',
                                                                            style:
                                                                                TextStyleMontserratBoldWhite_13,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child: Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  // Image.asset(
                                                                                  //   'assets/images/Transaction/8.png',
                                                                                  //   width: 20,
                                                                                  // ),
                                                                                  // SizedBox(
                                                                                  //   width: 5,
                                                                                  // ),
                                                                                  // Text(
                                                                                  //   'Traveloka',
                                                                                  //   style:
                                                                                  //       TextStyleMontserratW600Blue3_15,
                                                                                  //   textAlign: TextAlign.center,
                                                                                  // ),
                                                                                  // SizedBox(
                                                                                  //   width: 5,
                                                                                  // ),
                                                                                  Text(getTransaction[index].orderDetail[0]["createdAt"].toString().substring(0, 10), style: TextStyleMontserratW500Blue3_13, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                    child: Image.network(
                                                                                      getTransaction[index].product["productImage"].toString(),
                                                                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                        return Image.asset(
                                                                                          'assets/images/default_empty.jpg',
                                                                                          fit: BoxFit.fill,
                                                                                          width: 80,
                                                                                          height: 80,
                                                                                        );
                                                                                      },
                                                                                      fit: BoxFit.fill,
                                                                                      width: 80,
                                                                                      height: 80,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        getTransaction[index].product["productName"],
                                                                                        style: TextStyleMontserratW600Blue2_15,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        getTransaction[index].product["productCurrency"].toString() +
                                                                                            ' ' +
                                                                                            fmf
                                                                                                .copyWith(
                                                                                                  amount: double.parse(getTransaction[index].orderDetail[0]["priceAmount"].toString()),
                                                                                                )
                                                                                                .output
                                                                                                .withoutFractionDigits,
                                                                                        style: TextStyleMontserratBoldBlue3_13,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        'Quantity : ' + getTransaction[index].orderDetail[0]["quantity"].toString(),
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
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Total Payment',
                                                                                        style: TextStyleMontserratBoldBlue3_13,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        getTransaction[index].product["productCurrency"].toString() +
                                                                                            ' ' +
                                                                                            fmf
                                                                                                .copyWith(
                                                                                                  amount: double.parse(getTransaction[index].orderDetail[0]["totalPrice"].toString()),
                                                                                                )
                                                                                                .output
                                                                                                .withoutFractionDigits,
                                                                                        style: TextStyleMontserratW600Blue2_13,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Order ID',
                                                                                        style: TextStyleMontserratBoldBlue3_13,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        getTransaction[index].orderDetail[0]["orderId"].toString(),
                                                                                        style: TextStyleMontserratW600Blue3_13,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ]),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container()
                                                          : Container());
                                        }),
                                  ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: 10,
                                itemBuilder: (BuildContext context, index) {
                                  print(categoriesItemSelectedValue);
                                  return InkWell(
                                    child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            color: whiteDDDDDD,
                                            border: Border.all(
                                                color: whiteD5DDE0, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Shimmer(
                                          duration: Duration(
                                              seconds: 3), //Default value
                                          interval: Duration(
                                              seconds:
                                                  1), //Default value: Duration(seconds: 0)
                                          color: Colors.white, //Default value
                                          colorOpacity: 0.5, //Default value
                                          enabled: true, //Default value
                                          direction:
                                              ShimmerDirection.fromLTRB(),
                                          child: Container(),
                                        )),
                                  );
                                }),
                          ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
              menu_layout(context, "Transaction"),
              Visibility(
                visible: loading2,
                child: Positioned(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: black220Color),
                )),
              ),
            ]))),
          )),
    );
  }
}
