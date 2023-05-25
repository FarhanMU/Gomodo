import 'dart:ffi';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/api/api_getCategory.dart';
import 'package:gomodo_mobile/api/api_getNotification.dart';
import 'package:gomodo_mobile/api/api_getProduct.dart';
import 'package:gomodo_mobile/api/api_getProvince.dart';
import 'package:gomodo_mobile/api/api_pushNotification.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/layout/menu_layout.dart';
import 'package:gomodo_mobile/model/model_getCategory.dart';
import 'package:gomodo_mobile/model/model_getProvince.dart';
import 'package:gomodo_mobile/model/model_getproduct.dart';
import 'package:gomodo_mobile/page/add_product_1.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/productList_2.dart';
import 'package:gomodo_mobile/page/transactionList_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/norifi_service.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'package:image_crop_plus/image_crop_plus.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../model/model_getNotification.dart';

class productList_1 extends StatefulWidget {
  @override
  State<productList_1> createState() => _productList_1State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _productList_1State extends State<productList_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final searchOrdersController = TextEditingController();

  String? provinceItemSelectedValue;
  String? categoriesItemSelectedValue;

  String sortOrder = "desc";
  String sortField = "productPriceAmount";
  String keyword = "";
  String _sortOrder = "desc";

  bool searchOrdersActive = true;
  bool loading = true;
  bool loadingNotif = true;
  int responsestatusCode = 0;
  List<String> allIdNotification = [];

  RefreshController refreshController = RefreshController();

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

  List<model_getproduct> getproduct = [];
  void getproductyfromApi() async {
    String categories = categoriesItemSelectedValue == null
        ? ''
        : categoriesItemSelectedValue.toString();
    String province = provinceItemSelectedValue == null
        ? ''
        : provinceItemSelectedValue.toString();

    if (sortOrder == "conditionHighToLow") {
      _sortOrder = "desc";
      sortField = "productPriceAmount";
    } else if (sortOrder == "conditionLowToHigh") {
      _sortOrder = "asc";
      sortField = "productPriceAmount";
    } else if (sortOrder == "asc") {
      _sortOrder = "asc";
      sortField = "createdAt";
    } else if (sortOrder == "desc") {
      _sortOrder = "desc";
      sortField = "createdAt";
    }

    keyword = searchOrdersController.text;
    api_getProduct
        .getProduct(
            "&category=$categories",
            "&province=$province",
            "&sortOrder=$_sortOrder",
            "&sortField=$sortField",
            "&keyword=$keyword")
        .then((response) {
      setState(() {
        loading = false;

        Iterable list = response;
        getproduct =
            list.map((model) => model_getproduct.fromJson(model)).toList();
      });
    });
  }

  List<model_getCategory> getCategory = [];
  void getCategoryfromApi() async {
    api_getCategory.getCategory().then((response) {
      setState(() {
        Iterable list = response;
        getCategory =
            list.map((model) => model_getCategory.fromJson(model)).toList();
        // print(response);
      });
    });
  }

  List<model_getProvince> getProvince = [];
  void getProvincefromApi() async {
    api_getProvince.getProvince().then((response) {
      setState(() {
        Iterable list = response;

        getProvince =
            list.map((model) => model_getProvince.fromJson(model)).toList();
        // print(response);
      });
    });
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getproductyfromApi();
    getCategoryfromApi();
    getProvincefromApi();
    getNotificationfromApi();
    setState(() {});
    refreshController.refreshCompleted();
  }

  void initState() {
    getproductyfromApi();
    getCategoryfromApi();
    getProvincefromApi();
    getNotificationfromApi();

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
    // print(box.read("access_token"));

    MoneyFormatter fmf = MoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(context).size.shortestSide;

// Determine if we should use mobile layout or not, 600 here is
// a common breakpoint for a typical 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;
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
                                                              // print('awwww');
                                                              // print(index);
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
                          'Product List',
                          style: TextStyleMontserratW500Blue3_17,
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
                              getproductyfromApi();
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
                                  'Search Products',
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
                                    return AlertDialog(content: StatefulBuilder(
                                        builder: (context, setState) {
                                      return SingleChildScrollView(
                                        child: Form(
                                          key: _formKey,
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
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Province',
                                                        style:
                                                            TextStyleMontserratW500Blue3_16,
                                                      ),
                                                    ],
                                                  ),
                                                  loading == false
                                                      ? Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          margin: EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                              border: Border.all(
                                                                  color:
                                                                      blackColor,
                                                                  width: 1)),
                                                          child: StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return getProvince
                                                                        .length ==
                                                                    0
                                                                ? Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            "Province Not Found",
                                                                            style:
                                                                                TextStyleMontserratW500Blue3_15,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : DropdownButtonHideUnderline(
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: getProvince.length,
                                                                        itemBuilder: (BuildContext context, index) {
                                                                          return DropdownButton2(
                                                                            isExpanded:
                                                                                true,
                                                                            hint:
                                                                                Text('Select Province', style: TextStyleMontserratW500Blue3_15),
                                                                            items: getProvince
                                                                                .map((item) => DropdownMenuItem<String>(
                                                                                      value: item.id.toString(),
                                                                                      child: Text(item.name, style: TextStyleMontserratW500Blue3_15),
                                                                                    ))
                                                                                .toList(),
                                                                            value:
                                                                                provinceItemSelectedValue,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                provinceItemSelectedValue = value as String;
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
                                                                          );
                                                                        }));
                                                          }))
                                                      : Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          margin: EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          decoration: BoxDecoration(
                                                              color: whiteDDDDDD,
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: blackColor, width: 1)),
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
                                                          )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Category',
                                                        style:
                                                            TextStyleMontserratW500Blue3_16,
                                                      ),
                                                    ],
                                                  ),
                                                  loading == false
                                                      ? Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          margin: EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                              border: Border.all(
                                                                  color:
                                                                      blackColor,
                                                                  width: 1)),
                                                          child: StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return getCategory
                                                                        .length ==
                                                                    0
                                                                ? Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            "Category Not Found",
                                                                            style:
                                                                                TextStyleMontserratW500Blue3_15,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : DropdownButtonHideUnderline(
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: getCategory.length,
                                                                        itemBuilder: (BuildContext context, index) {
                                                                          return DropdownButton2(
                                                                            isExpanded:
                                                                                true,
                                                                            hint:
                                                                                Text('Select Category', style: TextStyleMontserratW500Blue3_15),
                                                                            items: getCategory
                                                                                .map((item) => DropdownMenuItem<String>(
                                                                                      value: item.id.toString(),
                                                                                      child: Text(item.name, style: TextStyleMontserratW500Blue3_15),
                                                                                    ))
                                                                                .toList(),
                                                                            value:
                                                                                categoriesItemSelectedValue,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                categoriesItemSelectedValue = value as String;
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
                                                                          );
                                                                        }));
                                                          }))
                                                      : Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          margin: EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          decoration: BoxDecoration(
                                                              color: whiteDDDDDD,
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: blackColor, width: 1)),
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
                                                          )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        getproductyfromApi();
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
                                                      setState(() {
                                                        provinceItemSelectedValue =
                                                            null;
                                                        categoriesItemSelectedValue =
                                                            null;
                                                        _formKey.currentState!
                                                            .reset();
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }));
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
                                                        getproductyfromApi();
                                                      });
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
                                                        getproductyfromApi();
                                                      });
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
                                                        getproductyfromApi();
                                                      });
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
                                                        getproductyfromApi();
                                                      });
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => add_product_1()));
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
                                    // Icon(
                                    //   Icons.add,
                                    //   size: 15,
                                    //   color: whiteColor,
                                    // ),
                                    Text(
                                      'New Product',
                                      style: TextStyleMontserratW600White_15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              loading == false
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 17,
                      ),
                      margin: EdgeInsets.only(top: 210, bottom: 70),
                      child: getproduct.length == 0
                          ? SmartRefresher(
                              controller: refreshController,
                              onRefresh: onRefresh,
                              child: Center(
                                child: Text(
                                  "No Products Found",
                                  style: TextStyleMontserratW600Blue3_17,
                                ),
                              ),
                            )
                          : SmartRefresher(
                              controller: refreshController,
                              onRefresh: onRefresh,
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        useMobileLayout == true ? 200 : 300,
                                    crossAxisSpacing: 5,
                                    childAspectRatio:
                                        useMobileLayout == true ? 0.65 : 1,
                                  ),
                                  itemCount: getproduct.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        box.write(
                                            "idProduct",
                                            getproduct[index]
                                                .productId
                                                .toString());
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            productList_2()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            border: Border.all(
                                                color: whiteD5DDE0, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              Column(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  child: Image.network(
                                                    getproduct[index]
                                                        .featuredImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/default_empty.jpg',
                                                        fit: BoxFit.cover,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                      );
                                                    },
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                      child: Text(
                                                          getproduct[index]
                                                              .productName,
                                                          style:
                                                              TextStyleMontserratW600Blue2_15,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2),
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    //     Icon(
                                                    //       Icons.star_sharp,
                                                    //       color: Colors.yellow,
                                                    //       size: 22,
                                                    //     ),
                                                    //     Text(
                                                    //       '5',
                                                    //       style:
                                                    //           TextStyleMontserratW600Blue3_15,
                                                    //       textAlign:
                                                    //           TextAlign.start,
                                                    //     ),
                                                    //   ],
                                                    // )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.33,
                                                          child: Text(
                                                            'Price',
                                                            style:
                                                                TextStyleMontserratW500Blue3_15,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.38,
                                                          child: Text(
                                                            getproduct[index]
                                                                    .priceCurrency +
                                                                ' ' +
                                                                fmf
                                                                    .copyWith(
                                                                      amount: double.parse(getproduct[
                                                                              index]
                                                                          .priceAmount
                                                                          .toString()),
                                                                    )
                                                                    .output
                                                                    .withoutFractionDigits,
                                                            style:
                                                                TextStyleMontserratW600Blue2_13,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                              // Positioned(
                                              //   right: 0,
                                              //   child: Container(
                                              //     padding: EdgeInsets.symmetric(
                                              //         horizontal: 10, vertical: 5),
                                              //     decoration: BoxDecoration(
                                              //         color: Colors.red,
                                              //         borderRadius: BorderRadius.only(
                                              //           bottomLeft: Radius.circular(10),
                                              //           topRight: Radius.circular(10),
                                              //         )),
                                              //     child: Text(
                                              //       'Not Active',
                                              //       style: TextStyleMontserratW600White_12,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              Positioned(
                                                right: 0,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: getproduct[index]
                                                                  .status ==
                                                              "ACTIVE"
                                                          ? green28B710
                                                          : getproduct[index]
                                                                      .status ==
                                                                  "REQUEST_DEACTIVATE"
                                                              ? grayAAB1B3
                                                              : grayAAB1B3,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      )),
                                                  child: Text(
                                                    getproduct[index].status ==
                                                            "ACTIVE"
                                                        ? "Active"
                                                        : getproduct[index]
                                                                    .status ==
                                                                "REQUEST_DEACTIVATE"
                                                            ? 'Detactive Soon'
                                                            : '',
                                                    style:
                                                        TextStyleMontserratW600White_12,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 17,
                      ),
                      margin: EdgeInsets.only(top: 210, bottom: 70),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                useMobileLayout == true ? 200 : 300,
                            crossAxisSpacing: 5,
                            childAspectRatio:
                                useMobileLayout == true ? 0.65 : 1,
                          ),
                          itemCount: 10,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: whiteDDDDDD,
                                  border:
                                      Border.all(color: whiteD5DDE0, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Container(
                                  padding: EdgeInsets.all(10),
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
                            );
                          }),
                    ),
              menu_layout(context, "Product")
            ]))),
          )),
    );
  }
}
