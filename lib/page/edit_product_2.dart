import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';
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
import 'package:gomodo_mobile/api/api_addProduct.dart';
import 'package:gomodo_mobile/api/api_editProduct.dart';
import 'package:gomodo_mobile/api/api_getProductDetail.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/page/add_product_3.dart';
import 'package:gomodo_mobile/page/edit_product_1.dart';
import 'package:gomodo_mobile/page/edit_product_3.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class edit_product_2 extends StatefulWidget {
  List<String> productHighlight;
  List<String> productHighlightID;
  List<String> blackoutDate;
  List<File> photos;
  List<String> videos;
  List<String> videosId;
  List<String> operationalHourFrom;
  List<String> operationalHourTo;
  List<String> productPhotoUrlId;
  List<String> productPhotoUrl;

  edit_product_2(
      this.productHighlight,
      this.blackoutDate,
      this.photos,
      this.videos,
      this.operationalHourFrom,
      this.operationalHourTo,
      this.videosId,
      this.productHighlightID,
      this.productPhotoUrlId,
      this.productPhotoUrl);

  @override
  State<edit_product_2> createState() => _edit_product_2State(
      productHighlight,
      blackoutDate,
      photos,
      videos,
      operationalHourFrom,
      operationalHourTo,
      videosId,
      productHighlightID,
      productPhotoUrlId,
      productPhotoUrl);
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _edit_product_2State extends State<edit_product_2> {
  List<String> productHighlight;
  List<String> productHighlightID;
  List<String> blackoutDate;
  List<File> photos;
  List<String> productPhotoUrlId;
  List<String> videos;
  List<String> videosId;
  List<String> operationalHourFrom;
  List<String> operationalHourTo;
  List<String> productPhotoUrl;

  _edit_product_2State(
      this.productHighlight,
      this.blackoutDate,
      this.photos,
      this.videos,
      this.operationalHourFrom,
      this.operationalHourTo,
      this.videosId,
      this.productHighlightID,
      this.productPhotoUrlId,
      this.productPhotoUrl);

  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final productProductPriceController = TextEditingController();
  // final productUnitPriceController = TextEditingController();
  final productParticipantRecomendedController = TextEditingController();
  final productParticipantUnRecomendedController = TextEditingController();
  final productSpecialConditionController = TextEditingController();
  final productCapacityController = TextEditingController();
  final productFacilitySupportController = TextEditingController();
  final productAge_1Controller = TextEditingController();
  final productAge_2Controller = TextEditingController();

  int countOfHighlight = 1;
  int countOfPhotoProduct = 1;
  int countOfBlackOutDate = 1;

  bool registerClicked = false;

  List<String> productPhotoUrlBase64 = [];
  String createdAt = "";
  String validityStart = "";
  String validityEnd = "";
  String status = "";
  String latitude = "";
  String longitude = "";

  bool loadingGetAllData = true;

  void getDetailProductfromApi() async {
    EasyLoading.show(status: 'loading...');

    String idProduct = box.read("idProduct");
    api_getProductDetail.getProductDetail(idProduct).then((response) {
      setState(() {
        latitude = response.meetingPoint["latitude"].toString();
        longitude = response.meetingPoint["longitude"].toString();
        productProductPriceController.text = response.price.toString();
        // productUnitPriceController.text = response.priceCurrency.toString();
        createdAt = response.dateCreated.toString();
        productParticipantRecomendedController.text =
            response.participant.toString();
        productParticipantUnRecomendedController.text =
            response.notParticipant.toString();
        productSpecialConditionController.text =
            response.requirements.toString();
        productCapacityController.text = response.capacity.toString();
        productFacilitySupportController.text = response.facility.toString();
        validityStart = response.validityStart.toString();
        validityEnd = response.validityEnd.toString();
        productAge_1Controller.text = response.ageRangeFrom.toString();
        productAge_2Controller.text = response.ageRangeTo.toString();
        status = response.status.toString();
        loadingGetAllData = false;
        EasyLoading.dismiss();
      });
    });
  }

  void convertStringUrl() async {
    for (int i = 0; i < productPhotoUrl.length; i++) {
      final imgBase64Str = await networkImageToBase64(productPhotoUrl[i]);
      productPhotoUrlBase64.add('data:image/png;base64,' + imgBase64Str!);
    }

    for (int i = 0; i < photos.length; i++) {
      List<int> imageBytes = photos[i].readAsBytesSync();
      productPhotoUrlBase64
          .add('data:image/png;base64,' + base64Encode(imageBytes));
    }

    // print('productPhotoUrlBase64');
    // print(productPhotoUrlBase64);
  }

  void initState() {
    convertStringUrl();
    getDetailProductfromApi();
    super.initState();
  }

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

  bool loading2 = false;
  int responsestatusCode = 0;

  void api_updateProductfromApi(
    String productName,
    String productDescription,
    String category,
    String placeName,
    String meetingPointProvince,
    String meetingPointCity,
    String meetingPointAddress,
    List<String> productHighlight, //[]
    String validityStart,
    String validityEnd,
    List<String> blackoutDate, //[]
    List<String> photos, //[]
    List<String> videos, //[]
    List<String> operationalHourFrom,
    List<String> operationalHourTo,
    // String productPriceCurrency,
    String productPriceAmount,
    String participant,
    String notParticipant,
    String capacity,
    String facility,
    String requirements,
    String ageRangeFrom,
    String ageRangeTo,
    List<String> videosId, //[]
    List<String> productHighlightID, //[]
    List<String> productPhotoUrlId, //[]
  ) async {
    api_editProduct
        .editProduct(
            box.read("idProduct"),
            productName,
            productDescription,
            category,
            placeName,
            meetingPointProvince,
            meetingPointCity,
            meetingPointAddress,
            productHighlight, //[]
            validityStart,
            validityEnd,
            blackoutDate, //[]
            photos, //[]
            videos, //[]
            operationalHourFrom,
            operationalHourTo,
            // productPriceCurrency,
            productPriceAmount,
            participant,
            notParticipant,
            capacity,
            facility,
            requirements,
            ageRangeFrom,
            ageRangeTo,
            videosId,
            productHighlightID,
            productPhotoUrlId)
        .then((response) {
      setState(() {
        EasyLoading.dismiss();
        loading2 = false;
        responsestatusCode = response.statusCode;
        print(responsestatusCode);
        if (response.statusCode == 200) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => edit_product_3()));
        }
      });
    });
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   EasyLoading.dismiss();

    //   loading2 = false;
    // });
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    DateTime? currentBackPressTime;
    Future<bool> onWillPop() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => edit_product_1()),
          (Route<dynamic> route) => false);
      return Future.value(true);
    }

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
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => edit_product_1()),
                                    (Route<dynamic> route) => false);
                              },
                              child: header_layout("Edit Product")),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Please fill this form correctly!',
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
                                        'Product Price',
                                        style: TextStyleMontserratW500Blue2_16,
                                      ),
                                    ],
                                  ),
                                ),
                                // Column(
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           'Satuan Harga',
                                //           style: TextStyleMontserratW500Blue3_16,
                                //         ),
                                //         Text(
                                //           '*',
                                //           style: TextStyleMontserratW500Red_16,
                                //         ),
                                //       ],
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.symmetric(vertical: 10),
                                //       child: TextFormField(
                                //         controller: productUnitPriceController,
                                //         decoration: InputDecoration(
                                //           hintText: 'Satuan Harga',
                                //           fillColor: whiteColor,
                                //           filled: true,
                                //           border: new OutlineInputBorder(
                                //             borderRadius: const BorderRadius.all(
                                //               const Radius.circular(10),
                                //             ),
                                //             borderSide: new BorderSide(
                                //               color: defaultBlueColor,
                                //               width: 1.0,
                                //             ),
                                //           ),
                                //         ),
                                //         // The validator receives the text that the user has entered.
                                //         validator: (value) {
                                //           if (value == null || value.isEmpty) {
                                //             setState(() {});
                                //           }
                                //           return null;
                                //         },
                                //       ),
                                //     ),
                                //     Visibility(
                                //       visible:
                                //           productUnitPriceController.text != ''
                                //               ? false
                                //               : true,
                                //       child: Container(
                                //         width: MediaQuery.of(context).size.width,
                                //         child: Text(
                                //           registerClicked == false
                                //               ? ""
                                //               : 'Product Unit Must Be Filled',
                                //           style: TextStyleMontserratW500Red_15,
                                //           textAlign: TextAlign.start,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       height: 10,
                                //     ),
                                //   ],
                                // ),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Harga Produk',
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
                                        maxLength: 15,
                                        controller:
                                            productProductPriceController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          hintText: 'Harga Produk',
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
                                      visible:
                                          productProductPriceController.text !=
                                                  ''
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Product Price Must Be Filled',
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
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'More Information',
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
                                          'Peserta Dianjurkan',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller:
                                            productParticipantRecomendedController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'contoh: Sehat Jasmani, tidak takut ketinggian',
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
                                    ),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           'Peserta Tidak Dianjurkan',
                                //           style: TextStyleMontserratW500Blue3_16,
                                //         ),
                                //       ],
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.symmetric(vertical: 10),
                                //       child: TextFormField(
                                //         controller:
                                //             productParticipantUnRecomendedController,
                                //         decoration: InputDecoration(
                                //           hintText: 'Peserta Tidak Dianjurkan',
                                //           fillColor: whiteColor,
                                //           filled: true,
                                //           border: new OutlineInputBorder(
                                //             borderRadius: const BorderRadius.all(
                                //               const Radius.circular(10),
                                //             ),
                                //             borderSide: new BorderSide(
                                //               color: defaultBlueColor,
                                //               width: 1.0,
                                //             ),
                                //           ),
                                //         ),
                                //         // The validator receives the text that the user has entered.
                                //         validator: (value) {
                                //           if (value == null || value.isEmpty) {
                                //             setState(() {});
                                //           }
                                //           return null;
                                //         },
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       height: 10,
                                //     ),
                                //   ],
                                // ),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Syarat Khusus',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller:
                                            productSpecialConditionController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'contoh: sertifikasi diving, sertifikasi panjat tebing',
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
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Kapasitas',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: productCapacityController,
                                        decoration: InputDecoration(
                                          hintText: 'contoh: 40',
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
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Fasilitas Pendukung',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller:
                                            productFacilitySupportController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'contoh: makan siang, penginapan',
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
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Usia',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                                controller:
                                                    productAge_1Controller,
                                                decoration: InputDecoration(
                                                  hintText: '10',
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
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            '-',
                                            style:
                                                TextStyleMontserratBoldBlue3_15,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                                controller:
                                                    productAge_2Controller,
                                                decoration: InputDecoration(
                                                  hintText: '20',
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
                                            ),
                                          ],
                                        ),
                                      ],
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
                                    setState(() {
                                      registerClicked = true;
                                    });

                                    if (productProductPriceController.text != ''
                                        // &&
                                        // productUnitPriceController.text != ''
                                        // productParticipantRecomendedController.text !=
                                        //     '' &&
                                        // productParticipantUnRecomendedController
                                        //         .text !=
                                        //     '' &&
                                        // productSpecialConditionController.text !=
                                        //     '' &&
                                        // productCapacityController.text != '' &&
                                        // productFacilitySupportController.text !=
                                        //     '' &&
                                        // productAge_1Controller.text != '' &&
                                        // productAge_2Controller.text != ''
                                        ) {
                                      setState(() {
                                        loading2 = true;
                                      });

                                      EasyLoading.show(status: 'loading...');
                                      api_updateProductfromApi(
                                          box.read("productName"),
                                          box.read("productDescription"),
                                          box.read("category"),
                                          box.read("placeName"),
                                          box.read("meetingPointProvince"),
                                          box.read("meetingPointCity"),
                                          box.read("meetingPointAddress"),
                                          productHighlight,
                                          box.read("validityStart"),
                                          box.read("validityEnd"),
                                          blackoutDate,
                                          productPhotoUrlBase64,
                                          videos,
                                          operationalHourFrom,
                                          operationalHourTo,
                                          productProductPriceController.text,
                                          productParticipantRecomendedController
                                              .text,
                                          productParticipantUnRecomendedController
                                              .text,
                                          productCapacityController.text,
                                          productFacilitySupportController.text,
                                          productSpecialConditionController
                                              .text,
                                          productAge_1Controller.text,
                                          productAge_2Controller.text,
                                          videosId,
                                          productHighlightID,
                                          productPhotoUrlId);
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
                                      'Edit Product',
                                      style: TextStyleMontserratW600White_15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     // if (businessNameController.text != '' &&) {
                                //     //   Navigator.push(
                                //     //       context,
                                //     //       MaterialPageRoute(
                                //     //           builder: (context) => register_2()));
                                //     // } else {
                                //     //   setState(() {
                                //     //     if (businessNameController.text != '') {
                                //     //       validationBusinessNameController = false;
                                //     //     } else {
                                //     //       validationBusinessNameController = true;
                                //     //     }
                                //     //   });
                                //     // }
                                //   },
                                //   child: Container(
                                //     width: MediaQuery.of(context).size.width,
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: 15, vertical: 15),
                                //     decoration: BoxDecoration(
                                //         color: whiteColor,
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(10))),
                                //     child: Text(
                                //       'Save As Draft',
                                //       style: TextStyleMontserratW600Blue2_15,
                                //       textAlign: TextAlign.center,
                                //     ),
                                //   ),
                                // ),
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
          )),
    );
  }
}
