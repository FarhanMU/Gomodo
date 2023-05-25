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
import 'package:gomodo_mobile/api/api_loseAccessToPhone.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_3.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class login_3 extends StatefulWidget {
  @override
  State<login_3> createState() => _login_3State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _login_3State extends State<login_3> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  bool validationPhoneNumber = false;

  bool loading2 = false;
  bool registerClicked = false;
  int responsestatusCode = 0;

  void api_loseAccessToPhonefromApi(String phoneNumber) async {
    api_loseAccessToPhone.loseAccessToPhone(phoneNumber).then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => login_4()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

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
                            child: header_layout("Lose Access To Phone")),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'To continue the process you need to fill your registered phone number.',
                            style: TextStyleMontserratW500Blue3_15,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Phone Number',
                                    style: TextStyleMontserratW500Blue3_16,
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                    hintText: '085884768....',
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
                                visible: validationPhoneNumber,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    responsestatusCode == 404
                                        ? "Phone Number Must Be Filled"
                                        : "Email sent successfully",
                                    style: responsestatusCode == 200
                                        ? TextStyleMontserratW500Green_14
                                        : TextStyleMontserratW500Red_14,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  if (phoneNumberController.text != "") {
                                    EasyLoading.show(status: 'loading...');
                                    setState(() {
                                      loading2 = true;
                                    });

                                    api_loseAccessToPhonefromApi(
                                        phoneNumberController.text);
                                  } else {
                                    setState(() {
                                      validationPhoneNumber = true;
                                    });
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
