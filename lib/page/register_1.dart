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
import 'package:gomodo_mobile/api/api_getBusinessType.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/model/model_getBusinessType.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class register_1 extends StatefulWidget {
  @override
  State<register_1> createState() => _register_1State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _register_1State extends State<register_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final businessAdressController = TextEditingController();
  final businessPhoneNumberController = TextEditingController();
  final businessEmailController = TextEditingController();
  final buinessSocialMediaIGController = TextEditingController();
  final buinessSocialMediaFBController = TextEditingController();
  final establishedController = TextEditingController();
  final assoaiteNameController = TextEditingController();
  final assosiateMemberIdController = TextEditingController();
  RefreshController refreshController = RefreshController();

  bool registerClicked = false;
  bool loading = true;
  File? _file;
  File? _sample;

  List<model_getBusinessType> getBusinessType = [];
  void getBusinessTypefromApi() async {
    api_getBusinessType.getBusinessType().then((response) {
      setState(() {
        Iterable list = response;
        getBusinessType =
            list.map((model) => model_getBusinessType.fromJson(model)).toList();
        // print(response);
        loading = false;
      });
    });
  }

  void initState() {
    getBusinessTypefromApi();
    super.initState();
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getBusinessTypefromApi();

    setState(() {});
    refreshController.refreshCompleted();
  }

  String? businessTypeItemSelectedValue;

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
        home: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
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
                              child: header_layout("Register as Merchant")),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Please fill this register form correctly!',
                              style: TextStyleMontserratW500Blue3_15,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Business Information',
                                        style: TextStyleMontserratW500Blue2_16,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Name ',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: businessNameController,
                                        decoration: InputDecoration(
                                          hintText: 'Business Name',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: businessNameController.text != ''
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Business Name Must Be Filled',
                                          style: TextStyleMontserratW500Red_15,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Category ',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
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
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: blackColor,
                                                    width: 1)),
                                            child: getBusinessType.length == 0
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "No Category Found",
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
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            getBusinessType
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          return DropdownButton2(
                                                            isExpanded: true,
                                                            hint: Text(
                                                                'Business Type',
                                                                style:
                                                                    TextStyleMontserratW500Blue3_15),
                                                            items:
                                                                getBusinessType
                                                                    .map((item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item.name,
                                                                          child: Text(
                                                                              item.name,
                                                                              style: TextStyleMontserratW500Blue3_15),
                                                                        ))
                                                                    .toList(),
                                                            value:
                                                                businessTypeItemSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                businessTypeItemSelectedValue =
                                                                    value
                                                                        as String;
                                                                // box.write('pantryId',
                                                                //     businessTypeItemSelectedValue);
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
                                                        })),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                color: whiteDDDDDD,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: blackColor,
                                                    width: 1)),
                                            child: Shimmer(
                                              duration: Duration(
                                                  seconds: 3), //Default value
                                              interval: Duration(
                                                  seconds:
                                                      1), //Default value: Duration(seconds: 0)
                                              color:
                                                  Colors.white, //Default value
                                              colorOpacity: 0.5, //Default value
                                              enabled: true, //Default value
                                              direction:
                                                  ShimmerDirection.fromLTRB(),
                                              child: Container(),
                                            )),
                                    Visibility(
                                      visible:
                                          businessTypeItemSelectedValue != null
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Business Category Must Be Filled',
                                          style: TextStyleMontserratW500Red_15,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Address ',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Stack(
                                        children: [
                                          TextFormField(
                                            controller:
                                                businessAdressController,
                                            decoration: InputDecoration(
                                              hintText: 'jalan mawar IV',
                                              fillColor: whiteColor,
                                              filled: true,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
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
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {});
                                              }
                                              return null;
                                            },
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 20,
                                            child: Icon(
                                              Icons.location_on_rounded,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          businessAdressController.text != ''
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Business Adress Must Be Filled',
                                          style: TextStyleMontserratW500Red_15,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Phone Number',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller:
                                            businessPhoneNumberController,
                                        decoration: InputDecoration(
                                          hintText: '08588 987 09089',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Email',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: businessEmailController,
                                        decoration: InputDecoration(
                                          hintText: 'example@mail.com',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Business Social Media',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/images/Register/5.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                controller:
                                                    buinessSocialMediaIGController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'https://www.instagram.com/passpro_/',
                                                  fillColor: whiteColor,
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {});
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/images/Register/4.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                controller:
                                                    buinessSocialMediaFBController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'https://www.facebook.com/Farhanh4ns',
                                                  fillColor: whiteColor,
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {});
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Establish In',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: establishedController,
                                        decoration: InputDecoration(
                                          hintText: '2022',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Association name',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: assoaiteNameController,
                                        decoration: InputDecoration(
                                          hintText: 'Association name',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Association member ID',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: assosiateMemberIdController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          hintText: 'Association member ID',
                                          fillColor: whiteColor,
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            setState(() {});
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      registerClicked = true;
                                    });

                                    if (businessNameController.text != '' &&
                                        businessTypeItemSelectedValue != null &&
                                        businessAdressController.text != '') {
                                      box.write(
                                          'businessNameController',
                                          businessPhoneNumberController.text ==
                                                  ''
                                              ? 'default'
                                              : businessPhoneNumberController
                                                  .text);
                                      box.write(
                                          'businessAdressController',
                                          businessAdressController.text
                                              .toString());
                                      box.write(
                                          'businessPhoneNumberController',
                                          businessPhoneNumberController.text
                                              .toString());
                                      box.write(
                                          'businessTypeItemSelectedValue',
                                          businessTypeItemSelectedValue
                                              .toString());
                                      box.write(
                                          'businessEmailController',
                                          businessEmailController.text
                                              .toString());
                                      box.write(
                                          'buinessSocialMediaIGController',
                                          buinessSocialMediaIGController.text ==
                                                  ''
                                              ? 'default'
                                              : buinessSocialMediaIGController
                                                  .text);
                                      box.write(
                                          'buinessSocialMediaFBController',
                                          buinessSocialMediaFBController.text ==
                                                  ''
                                              ? 'default'
                                              : buinessSocialMediaFBController
                                                  .text);
                                      box.write(
                                          'establishedController',
                                          establishedController.text == ''
                                              ? 'default'
                                              : establishedController.text);
                                      box.write(
                                          'assoaiteNameController',
                                          assoaiteNameController.text == ''
                                              ? 'default'
                                              : assoaiteNameController.text);
                                      box.write(
                                          'assosiateMemberIdController',
                                          assosiateMemberIdController.text == ''
                                              ? '000000000000000'
                                              : assosiateMemberIdController
                                                  .text);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  register_2()));
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: defaultBlueColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      'Next',
                                      style: TextStyleMontserratW600White_15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]))),
        ));
  }
}
