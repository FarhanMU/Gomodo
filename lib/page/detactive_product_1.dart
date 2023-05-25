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
import 'package:gomodo_mobile/api/api_detactiveReason.dart';
import 'package:gomodo_mobile/api/api_getDetactiveReason.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/model/model_getDetactiveReason.dart';
import 'package:gomodo_mobile/page/detactive_product_2.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/productList_1.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/transactionList_1.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class detactive_product_1 extends StatefulWidget {
  @override
  State<detactive_product_1> createState() => _detactive_product_1State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _detactive_product_1State extends State<detactive_product_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final reasonDescriptionController = TextEditingController();

  bool validationReasonTitleController = false;
  bool validationReasonDescriptionControllerController = false;

  bool loading = true;
  bool loading2 = false;
  int responsestatusCode = 0;

  void delayGetData() async {
    await Future.delayed(Duration(seconds: 5));
    getDetactiveReasonfromApi();
  }

  List<model_getDetactiveReason> getDetactiveReason = [];
  void getDetactiveReasonfromApi() async {
    api_getDetactiveReason.getDetactiveReason().then((response) {
      setState(() {
        Iterable list = response;
        getDetactiveReason = list
            .map((model) => model_getDetactiveReason.fromJson(model))
            .toList();
        // print(response);
      });
    });
  }

  void api_detactiveReasonfromApi(
      String deactiveReason, String deactiveDesc, String id) async {
    api_detactiveReason
        .detactiveReason(deactiveReason, deactiveDesc, id)
        .then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => productList_1()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  void initState() {
    getDetactiveReasonfromApi();
    super.initState();
  }

  String? categoriesItemSelectedValue;

  DateTime? currentBackPressTime;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime? _dateTime_1;
  DateTime? _dateTime_2;

  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

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
        home: Scaffold(
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
                          child: header_layout("Deactivate Product")),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'By filling this form your product will be deactivate!',
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Why do you want to deactivate this product?',
                                      style: TextStyleMontserratW500Blue3_16,
                                    ),
                                  ],
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: blackColor, width: 1)),
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return DropdownButtonHideUnderline(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  getDetactiveReason.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Text('Select Reason',
                                                      style:
                                                          TextStyleMontserratW500Blue3_15),
                                                  items: getDetactiveReason
                                                      .map((item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item.name
                                                                .toString(),
                                                            child: Text(
                                                                item.name,
                                                                style:
                                                                    TextStyleMontserratW500Blue3_15),
                                                          ))
                                                      .toList(),
                                                  value:
                                                      categoriesItemSelectedValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      categoriesItemSelectedValue =
                                                          value as String;
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
                                    })),
                                Visibility(
                                  visible: validationReasonTitleController,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'Select Your Reason Must Be Filled',
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
                                      'Reason description',
                                      style: TextStyleMontserratW500Blue3_16,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: TextFormField(
                                    minLines: 5,
                                    maxLines: 10,
                                    controller: reasonDescriptionController,
                                    decoration: InputDecoration(
                                      hintText: 'Reason description',
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
                                      validationReasonDescriptionControllerController,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'Reason Description Must Be Filled',
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
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                if (reasonDescriptionController.text != '' ||
                                    categoriesItemSelectedValue != null) {
                                  if (reasonDescriptionController.text == '') {
                                    validationReasonDescriptionControllerController =
                                        true;
                                  } else {
                                    validationReasonDescriptionControllerController =
                                        false;
                                  }

                                  if (categoriesItemSelectedValue == null) {
                                    validationReasonTitleController = true;
                                  } else {
                                    validationReasonTitleController = false;
                                  }

                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      'Are you sure you want to deactivate this product?',
                                                      style:
                                                          TextStyleMontserratW500Blue2_15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);

                                                      api_detactiveReasonfromApi(
                                                          categoriesItemSelectedValue!,
                                                          reasonDescriptionController
                                                              .text,
                                                          box.read(
                                                              "idProduct"));

                                                      setState(() {
                                                        loading2 = true;
                                                      });

                                                      EasyLoading.show(
                                                          status: 'loading...');
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
                                                        'Yes',
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
                                                      Navigator.pop(context);
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
                                                        'Cancel',
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
                                    },
                                  );
                                } else {
                                  setState(() {
                                    if (reasonDescriptionController.text ==
                                        '') {
                                      validationReasonDescriptionControllerController =
                                          true;
                                    } else {
                                      validationReasonDescriptionControllerController =
                                          false;
                                    }

                                    if (categoriesItemSelectedValue == null) {
                                      validationReasonTitleController = true;
                                    } else {
                                      validationReasonTitleController = false;
                                    }
                                  });
                                }
                                ;
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  'Submit',
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
        ]))));
  }
}
