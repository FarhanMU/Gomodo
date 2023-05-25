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
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_3.dart';
import 'package:gomodo_mobile/page/register_1.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class login_1 extends StatefulWidget {
  @override
  State<login_1> createState() => _login_1State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _login_1State extends State<login_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  bool validationPhoneNumber = false;

  bool loading2 = false;
  bool registerClicked = false;

  int responsestatusCode = 0;

  void initState() {
    super.initState();
  }

  void api_loginfromApi(String phone) async {
    api_login.login(phone).then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => login_2()));
        }
      });
    });
  }

  whatsapp() async {
    var contact = "+6287777749293";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      EasyLoading.showError('WhatsApp is not installed.');
    }
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
                            child: header_layout("Log in")),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Please fill your phone number to login to your Gomodo account.',
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
                                visible: validationPhoneNumber,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    responsestatusCode == 404
                                        ? "Phone Number Must Be Correct"
                                        : "OTP code sent successfully. Please check your whatsapp",
                                    style: responsestatusCode == 200
                                        ? TextStyleMontserratW500Green_14
                                        : TextStyleMontserratW500Red_14,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
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
                                                      'What Can We Help You',
                                                      style:
                                                          TextStyleMontserratW500Blue2_15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              login_3()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: whiteDDDDDD)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Lose Access Phone',
                                                        style:
                                                            TextStyleMontserratW600Blue3_15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  whatsapp();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: whiteDDDDDD)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Contact Us',
                                                        style:
                                                            TextStyleMontserratW600Blue3_15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Need Help?',
                                      style: TextStyleMontserratW500Blue2_16,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    validationPhoneNumber = true;
                                  });
                                  if (phoneNumberController.text.length > 0) {
                                    api_loginfromApi(
                                        phoneNumberController.text);

                                    setState(() {
                                      loading2 = true;
                                    });

                                    EasyLoading.show(status: 'loading...');

                                    box.write(
                                        "phone", phoneNumberController.text);
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
                                    'Request Pin',
                                    style: TextStyleMontserratW600White_15,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Don’t have an account?',
                                        style: TextStyleMontserratW500Blue3_15,
                                        textAlign: TextAlign.center,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      register_1()));
                                        },
                                        child: Text(
                                          ' Register',
                                          style:
                                              TextStyleMontserratW600Blue2_15,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
