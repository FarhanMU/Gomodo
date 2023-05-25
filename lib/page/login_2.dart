import 'dart:async';
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
import 'package:gomodo_mobile/api/api_login.dart';
import 'package:gomodo_mobile/api/api_loginVerify.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_3.dart';
import 'package:gomodo_mobile/page/productList_1.dart';
import 'package:gomodo_mobile/page/transactionList_1.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class login_2 extends StatefulWidget {
  @override
  State<login_2> createState() => _login_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _login_2State extends State<login_2> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final digitNumber1Controller = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  bool loading2 = false;
  bool registerClicked = false;
  bool validationPhoneNumber = false;

  int responsestatusCode = 0;

  void api_loginfromApi(String phone) async {
    api_login.login(phone).then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {}
      });
    });
  }

  void api_loginVerifyfromApi(String phone, String otp) async {
    api_loginVerify.loginVerify(phone, otp).then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        box.write("access_token", response.access_token);
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => productList_1()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  final focus = FocusNode();

  //timer
  Timer? _timer;
  int _start = 60;
  bool activeTimer = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            activeTimer = false;
            validationPhoneNumber = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: whiteColor,
        builder: EasyLoading.init(),
        home: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              body: SafeArea(
                  child: Stack(children: [
            Stack(
              children: [
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
                                child: header_layout("Verification Pin")),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Text(
                                    'The verification pin has been sent to your WhatsApp number ****  ****  *',
                                    style: TextStyleMontserratW500Blue3_15,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    box.read("phone").toString().substring(
                                        box.read("phone").toString().length -
                                            4),
                                    style: TextStyleMontserratW500Blue3_15,
                                    textAlign: TextAlign.center,
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Text(
                                  //   'Pin expiration time is 120s.',
                                  //   style: TextStyleMontserratW600Blue3_15,
                                  //   textAlign: TextAlign.center,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Please enter the pin:',
                                          style:
                                              TextStyleMontserratW500Blue3_15,
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    Form(
                                      key: formKey,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 30),
                                          child: PinCodeTextField(
                                            appContext: context,
                                            pastedTextStyle: TextStyle(
                                              color: defaultBlueColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            length: 6,
                                            obscureText: true,
                                            obscuringCharacter: '*',
                                            blinkWhenObscuring: true,
                                            animationType: AnimationType.fade,
                                            errorTextSpace: 30,
                                            validator: (v) {
                                              if (v!.length < 3) {
                                                return " Masukan Pin Dengan Benar";
                                              } else {
                                                return null;
                                              }
                                            },
                                            pinTheme: PinTheme(
                                              shape: PinCodeFieldShape.box,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              fieldHeight: 50,
                                              fieldWidth: 40,
                                              activeFillColor: Colors.white,
                                              selectedFillColor: whiteColor,
                                              inactiveFillColor: whiteColor,
                                            ),
                                            cursorColor: Colors.black,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            enableActiveFill: true,
                                            errorAnimationController:
                                                errorController,
                                            controller: digitNumber1Controller,
                                            keyboardType: TextInputType.number,
                                            boxShadows: const [
                                              BoxShadow(
                                                offset: Offset(0, 1),
                                                color: Colors.black12,
                                                blurRadius: 10,
                                              )
                                            ],
                                            onCompleted: (v) {
                                              formKey.currentState!.validate();
                                              api_loginVerifyfromApi(
                                                  box.read("phone"),
                                                  currentText);
                                              // conditions for validating
                                              if (currentText.length != 6 ||
                                                  responsestatusCode != 200) {
                                                errorController!.add(
                                                    ErrorAnimationType
                                                        .shake); // Triggering error shake animation
                                                setState(() => hasError = true);
                                              } else {
                                                setState(
                                                  () {
                                                    hasError = false;

                                                    // snackBar("OTP Verified!!");
                                                  },
                                                );
                                              }
                                              debugPrint("Completed");
                                            },
                                            // onTap: () {
                                            //   print("Pressed");
                                            // },
                                            onChanged: (value) {
                                              debugPrint(value);
                                              setState(() {
                                                currentText = value;
                                              });
                                            },
                                            beforeTextPaste: (text) {
                                              debugPrint(
                                                  "Allowing to paste $text");
                                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                              return true;
                                            },
                                          )),
                                    ),

                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: <Widget>[
                                    //     Flexible(
                                    //         child: TextButton(
                                    //       child: const Text("Clear"),
                                    //       onPressed: () {
                                    //         digitNumber1Controller.clear();
                                    //       },
                                    //     )),
                                    //     Flexible(
                                    //         child: TextButton(
                                    //       child: const Text("Set Text"),
                                    //       onPressed: () {
                                    //         setState(() {
                                    //           digitNumber1Controller.text =
                                    //               "123456";
                                    //         });
                                    //       },
                                    //     )),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Please wait for $_start seconds to resend the pin.',
                                style: TextStyleMontserratW500Blue3_13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: validationPhoneNumber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "otp has been resent ",
                                  style: TextStyleMontserratW500Green_14,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!activeTimer) {
                                  _start = 60;
                                  activeTimer = true;
                                  startTimer();
                                  validationPhoneNumber = true;
                                  api_loginfromApi(box.read("phone"));
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                  color: activeTimer == false
                                      ? defaultBlueColor
                                      : whiteD5DDE0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                'Request Pin',
                                style: activeTimer == false
                                    ? TextStyleMontserratW600White_15
                                    : TextStyleMontserratW600White_15,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            )
          ]))),
        ));
  }
}
