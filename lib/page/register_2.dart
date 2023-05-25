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
import 'package:gomodo_mobile/api/api_register.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/register_3.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class register_2 extends StatefulWidget {
  @override
  State<register_2> createState() => _register_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _register_2State extends State<register_2> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final ownerPhoneNumberController = TextEditingController();
  final ownerAdressController = TextEditingController();
  final ownerIdCardController = TextEditingController();
  final ownerEmailController = TextEditingController();

  bool loading2 = false;
  bool registerClicked = false;

  int responsestatusCode = 0;
  String message = '';

  void initState() {
    super.initState();
  }

  DateTime? currentBackPressTime;

  void api_registerfromApi(
      String email,
      String phoneNumber,
      String ownerName,
      String ownerAddress,
      String idCardNum,
      String bankName,
      String bankAccountNumber,
      String bankAccountName,
      String businessName,
      String businessEmail,
      String businessPhoneNumber,
      String businessType,
      String businessAddress,
      String businessSocMedInstagram,
      String businessSocMedFacebook,
      int associationId) async {
    api_register
        .register(
            email,
            phoneNumber,
            ownerName,
            ownerAddress,
            idCardNum,
            bankName,
            bankAccountNumber,
            bankAccountName,
            businessName,
            businessEmail,
            businessPhoneNumber,
            businessType,
            businessAddress,
            businessSocMedInstagram,
            businessSocMedFacebook,
            associationId)
        .then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        message = response.message;
        print(responsestatusCode);
        if (response.statusCode == 201) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => register_3()));
        }
      });
    });
  }

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
            ListView(
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
                                      'Owner Information',
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
                                        'Owner Name ',
                                        style: TextStyleMontserratW500Blue3_16,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyleMontserratW500Red_16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      controller: ownerNameController,
                                      decoration: InputDecoration(
                                        hintText: 'jessica',
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
                                          setState(() {});
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: ownerNameController.text != ''
                                        ? false
                                        : true,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        registerClicked == false
                                            ? ""
                                            : 'Owner Name Must Be Filled',
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
                                        'Owner Phone Number ',
                                        style: TextStyleMontserratW500Blue3_16,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyleMontserratW500Red_16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      controller: ownerPhoneNumberController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        hintText: '08588 987 09089',
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
                                          setState(() {});
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        ownerPhoneNumberController.text != ''
                                            ? false
                                            : true,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        registerClicked == false
                                            ? ""
                                            : 'Owner Phone Number Must Be Filled',
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
                                        'Owner address according to ID card ',
                                        style: TextStyleMontserratW500Blue3_16,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyleMontserratW500Red_16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      controller: ownerAdressController,
                                      decoration: InputDecoration(
                                        hintText: 'jalan mawar V2',
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
                                          setState(() {});
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: ownerAdressController.text != ''
                                        ? false
                                        : true,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        registerClicked == false
                                            ? ""
                                            : 'Owner Adsress Must Be Filled',
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
                                        'ID card number ',
                                        style: TextStyleMontserratW500Blue3_16,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyleMontserratW500Red_16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      controller: ownerIdCardController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        hintText: '1234567',
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
                                          setState(() {});
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: ownerIdCardController.text != ''
                                        ? false
                                        : true,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        registerClicked == false
                                            ? ""
                                            : 'Owner Id Card Must Be Filled',
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
                                        'Owner Email ',
                                        style: TextStyleMontserratW500Blue3_16,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyleMontserratW500Red_16,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      controller: ownerEmailController,
                                      decoration: InputDecoration(
                                        hintText: 'example@mail.com',
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
                                          setState(() {});
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: ownerEmailController.text != ''
                                        ? false
                                        : true,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        registerClicked == false
                                            ? ""
                                            : 'Owner Email Must Be Filled',
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
                              Visibility(
                                visible: responsestatusCode == 0 ? false : true,
                                child: Text(
                                  message,
                                  style: responsestatusCode == 201
                                      ? TextStyleMontserratW500Green_14
                                      : TextStyleMontserratW500Red_14,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    registerClicked = true;
                                  });

                                  // setState(() {
                                  //   loading2 = true;
                                  // });

                                  // EasyLoading.show(status: 'loading...');

                                  // api_registerfromApi(
                                  //     "obet529nf2@gmail.com",
                                  //     "085889863432",
                                  //     "farhan2",
                                  //     "jalan mandorsuki",
                                  //     "123123123123123",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     "default",
                                  //     000000000000000);

                                  if (ownerNameController.text != '' &&
                                      ownerEmailController != '' &&
                                      ownerAdressController.text != '' &&
                                      ownerIdCardController.text != '' &&
                                      ownerPhoneNumberController.text != '') {
                                    setState(() {
                                      loading2 = true;
                                    });

                                    EasyLoading.show(status: 'loading...');

                                    api_registerfromApi(
                                        ownerEmailController.text,
                                        ownerPhoneNumberController.text,
                                        ownerNameController.text,
                                        ownerAdressController.text,
                                        ownerIdCardController.text,
                                        "bankName",
                                        "bankAccountNumber",
                                        "bankAccountName",
                                        box.read("businessNameController"),
                                        box.read("businessEmailController"),
                                        box.read(
                                            "businessPhoneNumberController"),
                                        box.read(
                                            "businessTypeItemSelectedValue"),
                                        box.read("businessAdressController"),
                                        box.read(
                                            "buinessSocialMediaIGController"),
                                        box.read(
                                            "buinessSocialMediaFBController"),
                                        int.parse(box.read(
                                            "assosiateMemberIdController")));
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
                                    'Register',
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
        ));
  }
}
