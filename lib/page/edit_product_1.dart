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
import 'package:gomodo_mobile/api/api_getProductDetail.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/api/api_getCategory.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/model/model_getCategory.dart';
import 'package:gomodo_mobile/page/add_product_2.dart';
import 'package:gomodo_mobile/page/edit_product_2.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/productList_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gomodo_mobile/api/api_getProvince.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import '../model/model_getProvince.dart';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:gomodo_mobile/api/api_addProduct.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import '../untilities/custom.dart';

const kGoogleApiKey = 'AIzaSyBL1RVxtSo4LX2nrtIwNjGxHdDSFJWCqzE';

class edit_product_1 extends StatefulWidget {
  @override
  State<edit_product_1> createState() => _edit_product_1State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _edit_product_1State extends State<edit_product_1> {
  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productMeetingPointController = TextEditingController();
  final productCityController = TextEditingController();
  final productAddressController = TextEditingController();
  final productDeskriptionProductController = TextEditingController();
  List<String> productHighlightProduct = [];
  List<String> productHighlightProductId = [];
  List<String> productBlackOutDates = [];
  List<String> productLinkYoutube = [];
  List<String> productLinkYoutubeId = [];
  List<String> productOperationalHoursFrom = [];
  List<String> productOperationalHoursTo = [];
  final productValidityStartController = TextEditingController();
  final productValidityEndController = TextEditingController();
  List<File> productPhoto = [];
  List<String> productPhotoUrl = [];
  List<String> productPhotoUrlId = [];
  Mode _mode = Mode.overlay;

  bool registerClicked = false;

  bool loadingCategory = true;
  bool loadingProvince = true;
  String? provinceItemSelectedValue;
  String? categoryItemSelectedValue;

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  bool use24HourTime = true;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  String images = "";
  String province = "";
  List<dynamic> productHighlight = [];
  List<dynamic> images_v2 = [];
  List<dynamic> videos = [];
  List<dynamic> blackOutDate = [];
  String price = "";
  String priceCurrency = "";
  String createdAt = "";
  String participant = "";
  String notParticipant = "";
  String requirements = "";
  String capacity = "";
  String facility = "";
  String ageRangeFrom = "";
  String ageRangeTo = "";
  String status = "";
  String longitude = '';
  String lattitude = '';

  bool loadingGetAllData = true;

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

  String mondayTimeFrom = '0000';
  String tuesdayTimeFrom = '0000';
  String wednesdayTimeFrom = '0000';
  String thursdayTimeFrom = '0000';
  String fridayTimeFrom = '0000';
  String saturdayTimeFrom = '0000';
  String sundayTimeFrom = '0000';

  String mondayTimeTo = '0000';
  String tuesdayTimeTo = '0000';
  String wednesdayTimeTo = '0000';
  String thursdayTimeTo = '0000';
  String fridayTimeTo = '0000';
  String saturdayTimeTo = '0000';
  String sundayTimeTo = '0000';

  String mondayTimeFromText = '0000';
  String tuesdayTimeFromText = '0000';
  String wednesdayTimeFromText = '0000';
  String thursdayTimeFromText = '0000';
  String fridayTimeFromText = '0000';
  String saturdayTimeFromText = '0000';
  String sundayTimeFromText = '0000';

  String mondayTimeToText = '0000';
  String tuesdayTimeToText = '0000';
  String wednesdayTimeToText = '0000';
  String thursdayTimeToText = '0000';
  String fridayTimeToText = '0000';
  String saturdayTimeToText = '0000';
  String sundayTimeToText = '0000';

  List<model_getCategory> getCategory = [];
  void getCategoryfromApi() async {
    api_getCategory.getCategory().then((response) {
      setState(() {
        Iterable list = response;
        getCategory =
            list.map((model) => model_getCategory.fromJson(model)).toList();
        // print(response);
      });
      loadingCategory = false;
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
      loadingProvince = false;
    });
  }

  void getDetailProductfromApi() async {
    EasyLoading.show(status: 'loading...');

    String idProduct = box.read("idProduct");
    api_getProductDetail.getProductDetail(idProduct).then((response) {
      setState(() {
        productNameController.text = response.productName.toString();
        productMeetingPointController.text = response.placeName.toString();
        productCityController.text = response.cityName.toString();
        productAddressController.text = response.placeName.toString();

        categoryItemSelectedValue =
            response.productCategory[0]["categoryId"].toString();

        provinceItemSelectedValue = response.province["id"].toString();

        images =
            response.images.length == 0 ? '-' : response.images[0].toString();
        images_v2 = response.images_v2;
        for (int i = 0; i < images_v2.length; i++) {
          productPhotoUrl.add(images_v2[i]['url'].toString());
          productPhotoUrlId.add(images_v2[i]['id'].toString());
        }

        for (int i = 0; i < response.operationalHours.length; i++) {
          if (response.operationalHours[i]['day'] == 'monday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[mondayFrom]');
            productOperationalHoursTo.add('operationalHour[mondayTo]');
            mondayTimeFrom = response.operationalHours[i]['from'].toString();
            mondayTimeTo = response.operationalHours[i]['to'].toString();
            mondayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            mondayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            monday = true;
          }

          if (response.operationalHours[i]['day'] == 'tuesday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[tuesdayFrom]');
            productOperationalHoursTo.add('operationalHour[tuesdayTo]');
            tuesdayTimeFrom = response.operationalHours[i]['from'].toString();
            tuesdayTimeTo = response.operationalHours[i]['to'].toString();
            tuesdayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            tuesdayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            tuesday = true;
          }

          if (response.operationalHours[i]['day'] == 'wednesday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[wednesdayFrom]');
            productOperationalHoursTo.add('operationalHour[wednesdayTo]');
            wednesdayTimeFrom = response.operationalHours[i]['from'].toString();
            wednesdayTimeTo = response.operationalHours[i]['to'].toString();
            wednesdayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            wednesdayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            wednesday = true;
          }

          if (response.operationalHours[i]['day'] == 'thursday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[thursdayFrom]');
            productOperationalHoursTo.add('operationalHour[thursdayTo]');
            thursdayTimeFrom = response.operationalHours[i]['from'].toString();
            thursdayTimeTo = response.operationalHours[i]['to'].toString();
            thursdayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            thursdayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            thursday = true;
          }

          if (response.operationalHours[i]['day'] == 'friday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[fridayFrom]');
            productOperationalHoursTo.add('operationalHour[fridayTo]');
            fridayTimeFrom = response.operationalHours[i]['from'].toString();
            fridayTimeTo = response.operationalHours[i]['to'].toString();
            fridayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            fridayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            friday = true;
          }

          if (response.operationalHours[i]['day'] == 'saturday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[saturdayFrom]');
            productOperationalHoursTo.add('operationalHour[saturdayTo]');
            saturdayTimeFrom = response.operationalHours[i]['from'].toString();
            saturdayTimeTo = response.operationalHours[i]['to'].toString();
            saturdayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            saturdayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            saturday = true;
          }

          if (response.operationalHours[i]['day'] == 'sunday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            productOperationalHoursFrom.add('operationalHour[sundayFrom]');
            productOperationalHoursTo.add('operationalHour[sundayTo]');
            sundayTimeFrom = response.operationalHours[i]['from'].toString();
            sundayTimeTo = response.operationalHours[i]['to'].toString();
            sundayTimeFromText =
                response.operationalHours[i]['from'].toString().substring(0, 5);
            sundayTimeToText =
                response.operationalHours[i]['to'].toString().substring(0, 5);
            sunday = true;
          }
        }

        province = response.province["name"].toString();
        lattitude = response.meetingPoint["latitude"];
        longitude = response.meetingPoint["longitude"];
        productHighlight = response.productHighlight;
        for (int i = 0; i < productHighlight.length; i++) {
          productHighlightProduct
              .add(productHighlight[i]['highlight'].toString());
          productHighlightProductId.add(productHighlight[i]['id'].toString());
        }
        videos = response.videos;
        for (int i = 0; i < videos.length; i++) {
          productLinkYoutube.add(videos[i]['videoUrl'].toString());
          productLinkYoutubeId.add(videos[i]['id'].toString());
        }

        price = response.price.toString();
        priceCurrency = response.priceCurrency.toString();
        productDeskriptionProductController.text =
            response.productDescription.toString();
        createdAt = response.dateCreated.toString();
        blackOutDate = response.blackOutDate;
        for (int i = 0; i < blackOutDate.length; i++) {
          productBlackOutDates.add(blackOutDate[i]['date']);
        }
        participant = response.participant.toString();
        notParticipant = response.notParticipant.toString();
        requirements = response.requirements.toString();
        capacity = response.capacity.toString();
        facility = response.facility.toString();
        productValidityStartController.text =
            response.validityStart.toString().substring(0, 10);
        productValidityEndController.text =
            response.validityEnd.toString().substring(0, 10);
        ageRangeFrom = response.ageRangeFrom.toString();
        ageRangeTo = response.ageRangeTo.toString();
        status = response.status.toString();
        loadingGetAllData = false;
        EasyLoading.dismiss();
      });
    });
  }

  void initState() {
    productValidityStartController.text =
        new DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    productValidityEndController.text =
        new DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    getCategoryfromApi();
    getProvincefromApi();
    getDetailProductfromApi();

    super.initState();
  }

  Future<void> _openImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.toInt() * 2,
    );

    productPhoto.add(sample);

    setState(() {});

    // print('sample file');
    // print(_sample);
  }

  Future<void> _openImage_editUrl(String nameUrl) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.toInt() * 2,
    );

    productPhotoUrl.remove(nameUrl);
    productPhoto.add(sample);

    setState(() {});

    // print('sample file');
    // print(_sample);
  }

  Future<void> _openImage_edit(int index) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.toInt() * 2,
    );

    productPhoto[index].delete();
    productPhoto[index] = sample;

    setState(() {});

    // print('sample file');
    // print(_sample);
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => productList_2()),
        (Route<dynamic> route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
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
                                        builder: (context) => productList_2()),
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
                                        'Product Detail',
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
                                          'Product Name',
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
                                        controller: productNameController,
                                        decoration: InputDecoration(
                                          hintText: 'Product Name',
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
                                      visible: productNameController.text != ''
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Product Name Must Be Filled',
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
                                          'Meeting Point',
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
                                          InkWell(
                                            onTap: () {
                                              _handlePressButton();
                                            },
                                            child: TextFormField(
                                              enabled: false,
                                              controller:
                                                  productMeetingPointController,
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
                                          productMeetingPointController.text !=
                                                  ''
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Meeting Point Must Be Filled',
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
                                          'Category',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    loadingCategory == false
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
                                            child: StatefulBuilder(
                                                builder: (context, setState) {
                                              return getCategory.length == 0
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
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: getCategory
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  index) {
                                                            return DropdownButton2(
                                                              isExpanded: true,
                                                              hint: Text(
                                                                  'Select Category',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_15),
                                                              items: getCategory
                                                                  .map((item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value: item
                                                                            .id
                                                                            .toString(),
                                                                        child: Text(
                                                                            item
                                                                                .name,
                                                                            style:
                                                                                TextStyleMontserratW500Blue3_15),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  categoryItemSelectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  categoryItemSelectedValue =
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
                                      visible: categoryItemSelectedValue != null
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Category Must Be Filled',
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
                                          'Province',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    loadingProvince == false
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
                                            child: StatefulBuilder(
                                                builder: (context, setState) {
                                              return getProvince.length == 0
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
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: getProvince
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  index) {
                                                            return DropdownButton2(
                                                              isExpanded: true,
                                                              hint: Text(
                                                                  'Select Province',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_15),
                                                              items: getProvince
                                                                  .map((item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value: item
                                                                            .id
                                                                            .toString(),
                                                                        child: Text(
                                                                            item
                                                                                .name,
                                                                            style:
                                                                                TextStyleMontserratW500Blue3_15),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  provinceItemSelectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  provinceItemSelectedValue =
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
                                      visible: provinceItemSelectedValue != null
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Province Must Be Filled',
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
                                          'City',
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
                                        controller: productCityController,
                                        decoration: InputDecoration(
                                          hintText: 'City',
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
                                      visible: productCityController.text != ''
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'City Must Be Filled',
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
                                          'Adress',
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
                                        controller: productAddressController,
                                        decoration: InputDecoration(
                                          hintText: 'Address',
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
                                          productAddressController.text != ''
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Address Must Be Filled',
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
                                          'Product Description',
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
                                        controller:
                                            productDeskriptionProductController,
                                        minLines: 5,
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          hintText: 'Product Description',
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
                                        // The validator receives the t ext that the user has entered.
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
                                          productDeskriptionProductController
                                                      .text !=
                                                  ''
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Product Description Must Be Filled',
                                          style: TextStyleMontserratW500Red_15,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible:
                                          productDeskriptionProductController
                                                      .text.length >=
                                                  5
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Product description length must be at least 5 characters long',
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
                                          'Highlight Product (max. 3 poin)',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: productHighlight.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          final productHighlightProductController =
                                              TextEditingController();

                                          productHighlightProductController
                                                  .text =
                                              productHighlightProduct[index];

                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: TextFormField(
                                                  controller:
                                                      productHighlightProductController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Product Highlight',
                                                    fillColor: whiteColor,
                                                    filled: true,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        const Radius.circular(
                                                            10),
                                                      ),
                                                      borderSide:
                                                          new BorderSide(
                                                        color: defaultBlueColor,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      print(value);
                                                      productHighlightProduct[
                                                          index] = value;
                                                    });
                                                  },
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
                                              Visibility(
                                                visible:
                                                    productHighlightProduct[
                                                                index] !=
                                                            ''
                                                        ? false
                                                        : true,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    registerClicked == false
                                                        ? ""
                                                        : 'Highlight Must Be Filled',
                                                    style:
                                                        TextStyleMontserratW500Red_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (productHighlightProduct.length <
                                              3) {
                                            productHighlightProduct.add('');
                                            productHighlight.add('');
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (productHighlightProduct.length >
                                              0) {
                                            productHighlightProduct
                                                .removeLast();
                                            productHighlight.removeLast();
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    Visibility(
                                      visible:
                                          productHighlightProduct.length != 0
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Highlight Must Be Added 3 Items',
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
                                          'Foto Produk (min.1, max 5)',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (productPhoto.length < 5) {
                                                _openImage();
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            padding: EdgeInsets.all(30),
                                            decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    color: defaultBlueColor,
                                                    width: 1)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: blackColor,
                                                )),
                                          ),
                                        ),
                                        Container(
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        productPhotoUrl.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _openImage_editUrl(productPhotoUrl[index]);
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            child:
                                                                                Image.network(
                                                                              productPhotoUrl[index],
                                                                              fit: BoxFit.fill,
                                                                              height: 80,
                                                                              width: 80,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                productPhotoUrl.remove(productPhotoUrl[index]);
                                                                                // productPhoto
                                                                                //     .removeLast();
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                              child: ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                  child: Icon(
                                                                                    Icons.remove_circle_rounded,
                                                                                    size: 25,
                                                                                    color: Colors.red,
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                      );
                                                    }),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        productPhoto.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _openImage_edit(index);
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            child:
                                                                                Image.file(
                                                                              fit: BoxFit.fill,
                                                                              height: 80,
                                                                              width: 80,
                                                                              productPhoto[index],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                // productPhotoUrl.remove(productPhotoUrl[index]);
                                                                                productPhoto.removeLast();
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                              child: ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                  child: Icon(
                                                                                    Icons.remove_circle_rounded,
                                                                                    size: 25,
                                                                                    color: Colors.red,
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Visibility(
                                    //   visible:
                                    //       productPhoto.length != 0 ? false : true,
                                    //   child: Container(
                                    //     width: MediaQuery.of(context).size.width,
                                    //     child: Text(
                                    //       registerClicked == false
                                    //           ? ""
                                    //           : 'Product Photo Must Be Filled',
                                    //       style: TextStyleMontserratW500Red_15,
                                    //       textAlign: TextAlign.start,
                                    //     ),
                                    //   ),
                                    // ),
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
                                          'Link Youtube Video Produk (max 3)',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: videos.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          final productLinkYoutubeController =
                                              TextEditingController();

                                          productLinkYoutubeController.text =
                                              productLinkYoutube[index];

                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: TextFormField(
                                                  controller:
                                                      productLinkYoutubeController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Youtube Link...',
                                                    fillColor: whiteColor,
                                                    filled: true,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        const Radius.circular(
                                                            10),
                                                      ),
                                                      borderSide:
                                                          new BorderSide(
                                                        color: defaultBlueColor,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      productLinkYoutube[
                                                          index] = value;
                                                    });
                                                  },
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
                                              Visibility(
                                                visible:
                                                    productLinkYoutube[index] !=
                                                            ''
                                                        ? false
                                                        : true,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    registerClicked == false
                                                        ? ""
                                                        : 'Link Youtube Must Be Filled',
                                                    style:
                                                        TextStyleMontserratW500Red_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productLinkYoutube.add('');
                                          videos.add('');
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (productLinkYoutube.length > 0) {
                                            productLinkYoutube.removeLast();
                                            videos.removeLast();
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    Visibility(
                                      visible: productLinkYoutube.length != 0
                                          ? false
                                          : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Link Youtube Must Be Added',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Validity',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyleMontserratW500Red_16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2099),
                                                      ).then((date) {
                                                        //tambahkan setState dan panggil variabel _dateTime.
                                                        setState(() {
                                                          _dateTime_1 = date;

                                                          productValidityStartController
                                                              .text = new DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  _dateTime_1!);
                                                        });
                                                      });
                                                    },
                                                    child: TextFormField(
                                                      enabled: false,
                                                      controller:
                                                          productValidityStartController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: _dateTime_1 ==
                                                                null
                                                            ? '<validityStart>'
                                                            : formatter
                                                                .format(
                                                                    _dateTime_1!)
                                                                .toString(),
                                                        fillColor: whiteColor,
                                                        filled: true,
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(10),
                                                          ),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                defaultBlueColor,
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
                                                  Positioned(
                                                      right: 10,
                                                      top: 20,
                                                      child: Image.asset(
                                                        'assets/images/Edit & Add Product/Calendar.png',
                                                        width: 25,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  productValidityStartController
                                                              .text !=
                                                          ''
                                                      ? false
                                                      : true,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  registerClicked == false
                                                      ? ""
                                                      : 'Validity Start Must Be Filled',
                                                  style:
                                                      TextStyleMontserratW500Red_15,
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
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            '-',
                                            style:
                                                TextStyleMontserratBoldBlue3_15,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2099),
                                                      ).then((date) {
                                                        //tambahkan setState dan panggil variabel _dateTime.
                                                        setState(() {
                                                          _dateTime_2 = date;
                                                          productValidityEndController
                                                              .text = new DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  _dateTime_2!);
                                                        });
                                                      });
                                                    },
                                                    child: TextFormField(
                                                      enabled: false,
                                                      controller:
                                                          productValidityEndController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: _dateTime_2 ==
                                                                null
                                                            ? '<validityEnd>'
                                                            : formatter
                                                                .format(
                                                                    _dateTime_2!)
                                                                .toString(),
                                                        fillColor: whiteColor,
                                                        filled: true,
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(10),
                                                          ),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                defaultBlueColor,
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
                                                  Positioned(
                                                      right: 10,
                                                      top: 20,
                                                      child: Image.asset(
                                                        'assets/images/Edit & Add Product/Calendar.png',
                                                        width: 25,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  productValidityEndController
                                                              .text !=
                                                          ''
                                                      ? false
                                                      : true,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  registerClicked == false
                                                      ? ""
                                                      : 'Validity End Must Be Filled',
                                                  style:
                                                      TextStyleMontserratW500Red_15,
                                                  textAlign: TextAlign.start,
                                                ),
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
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Black Out Dates',
                                          style:
                                              TextStyleMontserratW500Blue3_16,
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: productBlackOutDates.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          final productBlackOutDateController =
                                              TextEditingController();

                                          productBlackOutDateController.text =
                                              productBlackOutDates[index];

                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextFormField(
                                              controller:
                                                  productBlackOutDateController,
                                              decoration: InputDecoration(
                                                hintText: 'Black Out Dates',
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
                                              onChanged: (value) {
                                                setState(() {
                                                  productBlackOutDates[index] =
                                                      value;
                                                });
                                              },
                                              // The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {});
                                                }
                                                return null;
                                              },
                                            ),
                                          );
                                        }),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productBlackOutDates.add('');
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (productBlackOutDates.length > 0) {
                                            productBlackOutDates.removeLast();
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: defaultBlueColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: blackColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Operational Hour',
                                      style: TextStyleMontserratW600Blue3_15,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (monday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[mondayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[mondayTo]');
                                                    monday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    mondayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    mondayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    mondayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    mondayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    if (time2 != null) {
                                                      productOperationalHoursFrom
                                                          .add(
                                                              'operationalHour[mondayFrom]');
                                                      productOperationalHoursTo.add(
                                                          'operationalHour[mondayTo]');
                                                      monday = true;
                                                    }
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    monday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_monday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Monday',
                                                                  style:
                                                                      TextStyleMontserratW600card_monday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$mondayTimeFromText - $mondayTimeToText'
                                                                      .toString(),
                                                                  style:
                                                                      TextStyleMontserratW500card_monday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (friday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[fridayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[fridayTo]');
                                                    friday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    fridayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    fridayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    fridayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');
                                                    fridayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[fridayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[fridayTo]');
                                                        friday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    friday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_friday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Friday',
                                                                  style:
                                                                      TextStyleMontserratW600card_friday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$fridayTimeFromText - $fridayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_friday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (tuesday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[tuesdayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[tuesdayTo]');

                                                    tuesday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    tuesdayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    tuesdayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });
                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    tuesdayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');
                                                    tuesdayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[tuesdayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[tuesdayTo]');
                                                        tuesday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    tuesday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_tuesday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Tuesday',
                                                                  style:
                                                                      TextStyleMontserratW600card_tuesday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$tuesdayTimeFromText - $tuesdayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_tuesday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (saturday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[saturdayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[saturdayTo]');
                                                    saturday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    saturdayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    saturdayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  setState(() {
                                                    saturdayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    saturdayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[saturdayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[saturdayTo]');
                                                        saturday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    saturday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_saturday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Saturday',
                                                                  style:
                                                                      TextStyleMontserratW600card_saturday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$saturdayTimeFromText -$saturdayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_saturday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (wednesday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[wednesdayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[wednesdayTo]');
                                                    wednesday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    wednesdayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    wednesdayTimeFromText =
                                                        time!
                                                            .toString()
                                                            .replaceAll(
                                                                'TimeOfDay(',
                                                                '')
                                                            .replaceAll(
                                                                ')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    wednesdayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    wednesdayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[wednesdayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[wednesdayTo]');
                                                        wednesday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity: wednesday == false
                                                    ? 0.6
                                                    : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_wednesday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Wednesday',
                                                                  style:
                                                                      TextStyleMontserratW600card_wednesday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$wednesdayTimeFromText - $wednesdayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_wednesday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (sunday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[sundayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[sundayTo]');
                                                    sunday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    sundayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');
                                                    sundayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    sundayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    sundayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');

                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[sundayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[sundayTo]');
                                                        sunday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    sunday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_sunday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Sunday',
                                                                  style:
                                                                      TextStyleMontserratW600card_sunday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$sundayTimeFromText - $sundayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_sunday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (thursday) {
                                                  setState(() {
                                                    productOperationalHoursFrom
                                                        .remove(
                                                            'operationalHour[thursdayFrom]');
                                                    productOperationalHoursTo
                                                        .remove(
                                                            'operationalHour[thursdayTo]');
                                                    thursday = false;
                                                  });
                                                } else {
                                                  final TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'From',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    thursdayTimeFrom = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    thursdayTimeFromText = time!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                  });

                                                  final TimeOfDay? time2 =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now(),
                                                    initialEntryMode: entryMode,
                                                    // orientation: orientation,
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      // We just wrap these environmental changes around the
                                                      // child in this builder so that we can apply the
                                                      // options selected above. In regular usage, this is
                                                      // rarely necessary, because the default values are
                                                      // usually used as-is.
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'To',
                                                            style:
                                                                TextStyleMontserratW600White_24,
                                                          ),
                                                          Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              materialTapTargetSize:
                                                                  tapTargetSize,
                                                            ),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      use24HourTime,
                                                                ),
                                                                child: child!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  setState(() {
                                                    thursdayTimeTo = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(':', '')
                                                        .replaceAll(')', '');

                                                    thursdayTimeToText = time2!
                                                        .toString()
                                                        .replaceAll(
                                                            'TimeOfDay(', '')
                                                        .replaceAll(')', '');
                                                    setState(() {
                                                      if (time2 != null) {
                                                        productOperationalHoursFrom
                                                            .add(
                                                                'operationalHour[thursdayFrom]');
                                                        productOperationalHoursTo
                                                            .add(
                                                                'operationalHour[thursdayTo]');
                                                        thursday = true;
                                                      }
                                                    });
                                                  });
                                                }
                                              },
                                              child: Opacity(
                                                opacity:
                                                    thursday == false ? 0.6 : 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ProductList/card_thursday.png',
                                                        height: 55,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Thursday',
                                                                  style:
                                                                      TextStyleMontserratW600card_thursday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '$thursdayTimeFromText - $thursdayTimeToText',
                                                                  style:
                                                                      TextStyleMontserratW500card_thursday_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          productOperationalHoursFrom.length !=
                                                  0
                                              ? false
                                              : true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          registerClicked == false
                                              ? ""
                                              : 'Operational Hours Must Be Select',
                                          style: TextStyleMontserratW500Red_15,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
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
                                      loadingGetAllData = true;

                                      EasyLoading.show(status: 'loading...');
                                    });

                                    bool productHighlightProductCheck = false;
                                    // bool linkYoutubeCheck = false;
                                    // bool productOperationalHoursFromCheck = false;
                                    // bool productOperationalHoursToCheck = false;
                                    print(productHighlightProduct.length);
                                    if (productHighlightProduct.length != 0) {
                                      for (int i = 0;
                                          i < productHighlightProduct.length;
                                          i++) {
                                        if (productHighlightProduct[i] == '') {
                                          productHighlightProductCheck = false;
                                        } else {
                                          productHighlightProductCheck = true;
                                        }
                                      }
                                    } else {
                                      productHighlightProductCheck = false;
                                    }

                                    // for (int i = 0;
                                    //     i < productOperationalHoursFrom.length;
                                    //     i++) {
                                    //   if (productOperationalHoursFrom[i] != '') {
                                    //     productOperationalHoursFromCheck = true;
                                    //   } else {
                                    //     productOperationalHoursFromCheck = false;
                                    //   }
                                    // }

                                    // for (int i = 0;
                                    //     i < productOperationalHoursTo.length;
                                    //     i++) {
                                    //   if (productOperationalHoursTo[i] != '') {
                                    //     productOperationalHoursToCheck = true;
                                    //   } else {
                                    //     productOperationalHoursToCheck = false;
                                    //   }
                                    // }

                                    // for (int i = 0;
                                    //     i < productLinkYoutube.length;
                                    //     i++) {
                                    //   if (productLinkYoutube[i] != '') {
                                    //     linkYoutubeCheck = true;
                                    //   } else {
                                    //     linkYoutubeCheck = false;
                                    //   }
                                    // }

                                    if (productNameController.text != '' &&
                                        productDeskriptionProductController.text !=
                                            '' &&
                                        productDeskriptionProductController
                                                .text.length >=
                                            5 &&
                                        categoryItemSelectedValue != null &&
                                        productMeetingPointController.text !=
                                            '' &&
                                        provinceItemSelectedValue != null &&
                                        productCityController.text != '' &&
                                        productAddressController.text != '' &&
                                        productHighlightProductCheck == true &&
                                        // linkYoutubeCheck == true &&
                                        productValidityStartController.text !=
                                            '' &&
                                        productValidityEndController.text !=
                                            '' &&
                                        // productBlackOutDates.length != 0 &&
                                        // productPhoto.length != 0 &&
                                        // productLinkYoutube.length != 0 &&
                                        productOperationalHoursFrom.length !=
                                            0 &&
                                        productOperationalHoursTo.length != 0) {
                                      box.write('productName',
                                          productNameController.text);

                                      box.write(
                                          'productDescription',
                                          productDeskriptionProductController
                                              .text);

                                      box.write('category',
                                          categoryItemSelectedValue);
                                      box.write('placeName',
                                          productMeetingPointController.text);

                                      box.write('meetingPointProvince',
                                          provinceItemSelectedValue);

                                      box.write('meetingPointCity',
                                          productCityController.text);

                                      box.write('meetingPointAddress',
                                          productAddressController.text);

                                      box.write('validityStart',
                                          productValidityStartController.text);

                                      box.write('validityEnd',
                                          productValidityEndController.text);

                                      // set hours
                                      box.write(
                                          'mondayTimeFrom', mondayTimeFrom);
                                      box.write(
                                          'tuesdayTimeFrom', tuesdayTimeFrom);
                                      box.write('wednesdayTimeFrom',
                                          wednesdayTimeFrom);
                                      box.write(
                                          'thursdayTimeFrom', thursdayTimeFrom);
                                      box.write(
                                          'fridayTimeFrom', fridayTimeFrom);
                                      box.write(
                                          'saturdayTimeFrom', saturdayTimeFrom);
                                      box.write(
                                          'sundayTimeFrom', sundayTimeFrom);

                                      box.write('longitude', longitude);

                                      box.write('lattitude', lattitude);

                                      box.write('mondayTimeTo', mondayTimeTo);
                                      box.write('tuesdayTimeTo', tuesdayTimeTo);
                                      box.write(
                                          'wednesdayTimeTo', wednesdayTimeTo);
                                      box.write(
                                          'thursdayTimeTo', thursdayTimeTo);
                                      box.write('fridayTimeTo', fridayTimeTo);
                                      box.write(
                                          'saturdayTimeTo', saturdayTimeTo);
                                      box.write('sundayTimeTo', sundayTimeTo);

                                      print(productHighlightProduct);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  edit_product_2(
                                                      productHighlightProduct,
                                                      productBlackOutDates,
                                                      productPhoto,
                                                      productLinkYoutube,
                                                      productOperationalHoursFrom,
                                                      productOperationalHoursTo,
                                                      productLinkYoutubeId,
                                                      productHighlightProductId,
                                                      productPhotoUrlId,
                                                      productPhotoUrl)));
                                    } else {
                                      setState(() {
                                        loadingGetAllData = false;
                                        EasyLoading.dismiss();
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
                visible: loadingGetAllData,
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

  Widget _buildDropdownMenu() {
    return DropdownButton<Mode>(
      value: _mode,
      items: const <DropdownMenuItem<Mode>>[
        DropdownMenuItem<Mode>(
          value: Mode.overlay,
          child: Text('Overlay'),
        ),
        DropdownMenuItem<Mode>(
          value: Mode.fullscreen,
          child: Text('Fullscreen'),
        ),
      ],
      onChanged: (m) {
        if (m != null) {
          setState(() => _mode = m);
        }
      },
    );
  }

  Future<void> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Unknown error'),
        ),
      );
    }

    // show input autocomplete with selected mode
    // then get the Prediction selected
    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'id',
      components: [Component(Component.country, 'id')],
      // TODO: Since we supports Flutter >= 2.8.0
      // ignore: deprecated_member_use
      resultTextStyle: Theme.of(context).textTheme.subtitle1,
    );

    await displayPrediction(p, ScaffoldMessenger.of(context), context);
  }

  Future<void> displayPrediction(Prediction? p,
      ScaffoldMessengerState messengerState, BuildContext context) async {
    if (p == null) {
      return;
    }

    // get detail (lat/lng)
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;
    setState(() {
      lattitude = lat.toString();
      longitude = lng.toString();
      productMeetingPointController.text = p.description.toString();
    });
    print('${p.description} $lat, $lng');

    // messengerState.showSnackBar(
    //   SnackBar(
    //     content: Text('${p.description} - $lat/$lng'),
    //   ),
    // );
  }
}
