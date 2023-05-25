import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
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
import 'package:gomodo_mobile/api/api_getProfile.dart';
import 'package:gomodo_mobile/api/api_pushProfile.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/customEditor_saveCustom_page.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../model/model_getProfile.dart';
import 'login_1.dart';

class profile_1 extends StatefulWidget {
  final File? _file;
  const profile_1(this._file);

  @override
  State<profile_1> createState() => _profile_1State(_file);
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _profile_1State extends State<profile_1> {
  File? _file;
  _profile_1State(this._file);

  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerAdressController = TextEditingController();
  final ownerIdCardController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final bankNameController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final bankAccountNameController = TextEditingController();

  bool loading = true;
  RefreshController refreshController = RefreshController();
  bool updateClicked = false;

  DateTime? currentBackPressTime;

  int id = 0;
  int userId = 0;
  int businessId = 0;
  String profilePicture = '';
  File? _sample;
  bool loading2 = false;
  int responsestatusCode = 0;

  Future<void> _openImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.toInt() * 2,
    );

    _sample?.delete();
    _file?.delete();

    _sample = sample;
    _file = file;

    print('sample file');
    print(_sample);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                customEditor_saveCustom_page(_sample, _file)));
  }

  void getTransactionfromApi() async {
    api_getProfile.getProfile().then((response) {
      setState(() {
        loading = false;
        print(loading);

        id = response.id;
        userId = response.userId;
        businessId = response.businessId;
        ownerNameController.text = response.ownerName;
        ownerAdressController.text = response.ownerAddress;
        ownerIdCardController.text = response.idCardNum;
        ownerEmailController.text = response.user['email'];
        ownerPhoneController.text = response.user['phoneNumber'];
        bankNameController.text = response.bankName;
        bankAccountNumberController.text = response.bankAccountNumber;
        bankAccountNameController.text = response.bankAccountName;
        profilePicture = response.user['profilePicture'].toString();
      });
    });
  }

  void api_pushProfilefromApi(
      String idCardNum,
      String bankName,
      String bankAccountNumber,
      String bankAccountName,
      String profilePicture) async {
    api_pushProfile
        .pushProfile(idCardNum, bankName, bankAccountNumber, bankAccountName,
            profilePicture)
        .then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Update Profile Success",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getTransactionfromApi();

    setState(() {});
    refreshController.refreshCompleted();
  }

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

  void initState() {
    getTransactionfromApi();
    super.initState();
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
        home: Scaffold(
            body: SafeArea(
                child: Stack(children: [
          SmartRefresher(
              controller: refreshController,
              onRefresh: onRefresh,
              child: loading == false
                  ? ListView(
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
                                    child: header_layout("My Profile")),
                                SizedBox(
                                  height: 20,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: whiteDDDDDD)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                child: _file == null
                                                    ? Image.network(
                                                        profilePicture,
                                                        fit: BoxFit.fill,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/empty_user.png',
                                                          fit: BoxFit.fill,
                                                        );
                                                      })
                                                    : Image.file(
                                                        _file!,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     showDialog<void>(
                                            //       context: context,
                                            //       barrierDismissible:
                                            //           false, // user must tap button!
                                            //       builder:
                                            //           (BuildContext context) {
                                            //         return AlertDialog(
                                            //           content:
                                            //               SingleChildScrollView(
                                            //             child: ListBody(
                                            //               children: <Widget>[
                                            //                 InkWell(
                                            //                   onTap: () {
                                            //                     Navigator.of(
                                            //                             context)
                                            //                         .pop();
                                            //                   },
                                            //                   child: Row(
                                            //                     children: [
                                            //                       Icon(
                                            //                         Icons
                                            //                             .close_rounded,
                                            //                         size: 18,
                                            //                         color:
                                            //                             defaultBlueColor,
                                            //                       ),
                                            //                       SizedBox(
                                            //                         width: 5,
                                            //                       ),
                                            //                       Text(
                                            //                         'Edit Profile Picture',
                                            //                         style:
                                            //                             TextStyleMontserratW500Blue2_15,
                                            //                       ),
                                            //                     ],
                                            //                   ),
                                            //                 ),
                                            //                 SizedBox(
                                            //                   height: 30,
                                            //                 ),
                                            //                 Column(
                                            //                   children: [
                                            //                     InkWell(
                                            //                       onTap: () {
                                            //                         setState(
                                            //                             () {
                                            //                           _file =
                                            //                               null;
                                            //                           profilePicture =
                                            //                               '';
                                            //                         });
                                            //                       },
                                            //                       child:
                                            //                           Container(
                                            //                         width: MediaQuery.of(
                                            //                                 context)
                                            //                             .size
                                            //                             .width,
                                            //                         padding: EdgeInsets.symmetric(
                                            //                             horizontal:
                                            //                                 15,
                                            //                             vertical:
                                            //                                 15),
                                            //                         decoration: BoxDecoration(
                                            //                             border: Border.all(
                                            //                                 width:
                                            //                                     1,
                                            //                                 color:
                                            //                                     whiteD5DDE0),
                                            //                             borderRadius:
                                            //                                 BorderRadius.all(Radius.circular(10))),
                                            //                         child: Text(
                                            //                           'Remove Current Picture',
                                            //                           style:
                                            //                               TextStyleMontserratW600Blue2_15,
                                            //                           textAlign:
                                            //                               TextAlign
                                            //                                   .center,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                     SizedBox(
                                            //                       height: 10,
                                            //                     ),
                                            //                     InkWell(
                                            //                       onTap: () {
                                            //                         _openImage();
                                            //                       },
                                            //                       child:
                                            //                           Container(
                                            //                         width: MediaQuery.of(
                                            //                                 context)
                                            //                             .size
                                            //                             .width,
                                            //                         padding: EdgeInsets.symmetric(
                                            //                             horizontal:
                                            //                                 15,
                                            //                             vertical:
                                            //                                 15),
                                            //                         decoration: BoxDecoration(
                                            //                             border: Border.all(
                                            //                                 width:
                                            //                                     1,
                                            //                                 color:
                                            //                                     whiteD5DDE0),
                                            //                             borderRadius:
                                            //                                 BorderRadius.all(Radius.circular(10))),
                                            //                         child: Text(
                                            //                           'Import from Gallery',
                                            //                           style:
                                            //                               TextStyleMontserratW600Blue2_15,
                                            //                           textAlign:
                                            //                               TextAlign
                                            //                                   .center,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //     );
                                            //   },
                                            //   child: Text(
                                            //     'Edit Profile Picture',
                                            //     style:
                                            //         TextStyleMontserratW500Blue2_15,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Owner Name ',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller: ownerNameController,
                                              decoration: InputDecoration(
                                                hintText: 'Owner Name',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible: ownerNameController
                                                              .text ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Owner Name Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller: ownerPhoneController,
                                              decoration: InputDecoration(
                                                hintText: 'Owner Phone Number',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible: ownerPhoneController
                                                              .text ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Owner Phone Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                'Owner Address',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller: ownerAdressController,
                                              decoration: InputDecoration(
                                                hintText: 'Owner Address',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible: ownerAdressController
                                                              .text ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Owner Address Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                'Owner Id Card',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: ownerIdCardController,
                                              decoration: InputDecoration(
                                                hintText: 'Owner Id Card',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible: ownerIdCardController
                                                              .text ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Id Card Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller: ownerEmailController,
                                              decoration: InputDecoration(
                                                hintText: 'Owner Email',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible: ownerEmailController
                                                              .text ==
                                                          ""
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Owner Email Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                'Bank Name ',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller: bankNameController,
                                              decoration: InputDecoration(
                                                hintText: 'Bank Name',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible:
                                                      bankNameController.text ==
                                                              ""
                                                          ? true
                                                          : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Bank Name Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                'Bank Account Number ',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller:
                                                  bankAccountNumberController,
                                              decoration: InputDecoration(
                                                hintText: 'Bank Account Number',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible:
                                                      bankAccountNumberController
                                                                  .text ==
                                                              ""
                                                          ? true
                                                          : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Bank Account Number Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
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
                                                'Bank Account Name ',
                                                style:
                                                    TextStyleMontserratW500Blue3_16,
                                              ),
                                              Text(
                                                '*',
                                                style:
                                                    TextStyleMontserratW500Red_16,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller:
                                                  bankAccountNameController,
                                              decoration: InputDecoration(
                                                hintText: 'Bank Account Name',
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
                                          ),
                                          updateClicked == false
                                              ? Container()
                                              : Visibility(
                                                  visible:
                                                      bankAccountNameController
                                                                  .text ==
                                                              ""
                                                          ? true
                                                          : false,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      'Bank Account Name Must Be Filled',
                                                      style:
                                                          TextStyleMontserratW500Red_15,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          // getTransactionDownloadfromApi();
                                          setState(() {
                                            updateClicked = false;
                                          });

                                          if (ownerNameController.text != '' &&
                                              ownerAdressController != null &&
                                              ownerIdCardController.text !=
                                                  '' &&
                                              ownerEmailController.text != '' &&
                                              bankNameController.text != '' &&
                                              bankAccountNumberController
                                                      .text !=
                                                  '' &&
                                              bankAccountNameController.text !=
                                                  '') {
                                            setState(() {
                                              loading2 = true;
                                            });

                                            EasyLoading.show(
                                                status: 'loading...');

                                            api_pushProfilefromApi(
                                                ownerIdCardController.text,
                                                bankNameController.text,
                                                bankAccountNumberController
                                                    .text,
                                                bankAccountNameController.text,
                                                '');
                                          } else {
                                            setState(() {
                                              updateClicked = true;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: defaultBlueColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Text(
                                            'Save',
                                            style:
                                                TextStyleMontserratW600White_15,
                                            textAlign: TextAlign.center,
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.65,
                                                              child: Text(
                                                                'Are you sure you want to Log Out from Gomodo?',
                                                                style:
                                                                    TextStyleMontserratW500Blue2_15,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              box.remove(
                                                                  'access_token');
                                                              Navigator.of(context).pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              welcomeScreen_2()),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          15),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      defaultBlueColor,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Text(
                                                                'Yes, Log Out',
                                                                style:
                                                                    TextStyleMontserratW600White_15,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          15),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyleMontserratW600Blue2_15,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Text(
                                            'Logout',
                                            style:
                                                TextStyleMontserratW600Blue2_15,
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
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 80),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )),
          loading == true
              ? Positioned(
                  top: 40,
                  left: 20,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: header_layout("My Profile")),
                )
              : Container(),
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
