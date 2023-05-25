import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
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
import 'package:gomodo_mobile/api/api_getProductDetail.dart';
import 'package:gomodo_mobile/layout/header_layout.dart';
import 'package:gomodo_mobile/model/model_getproduct.dart';
import 'package:gomodo_mobile/model/model_getproductDetail.dart';
import 'package:gomodo_mobile/page/detactive_product_1.dart';
import 'package:gomodo_mobile/page/edit_product_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/register_3.dart';
import 'package:gomodo_mobile/page/videoFullScreen.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'productList_1.dart';

class productList_2 extends StatefulWidget {
  @override
  State<productList_2> createState() => _productList_2State();
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _productList_2State extends State<productList_2> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GetStorage box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final ownerPhoneNumberController = TextEditingController();
  final ownerAdressController = TextEditingController();
  final ownerIdCardController = TextEditingController();
  final ownerEmailController = TextEditingController();

  bool validationOwnerNameController = false;
  bool validationOwnerPhoneNumberController = false;
  bool validationOwnerAdressController = false;
  bool validationOwnerIdCardController = false;
  bool validationOwnerEmailController = false;
  RefreshController refreshController = RefreshController();

  String productName = "";
  String images = "";
  String province = "";
  List<dynamic> productHighlight = [];
  List<dynamic> blackOutDate = [];
  List<String> blackOutDateData = [];
  List<dynamic> images_v2 = [];
  List<dynamic> videos = [];
  String productCategory = "";
  String price = "";
  String priceCurrency = "";
  String createdAt = "";
  String validityStart = "";
  String validityEnd = "";
  String productDescription = "";
  String participant = "";
  String notParticipant = "";
  String requirements = "";
  String capacity = "";
  String facility = "";
  String ageRangeFrom = "";
  String ageRangeTo = "";
  String status = "";
  String latitude = "";
  String longitude = "";

  List<String> allDay = [];

  bool loading = true;

  void getDetailProductfromApi() async {
    String idProduct = box.read("idProduct");
    api_getProductDetail.getProductDetail(idProduct).then((response) {
      setState(() {
        productName = response.productName.toString();
        images =
            response.images.length == 0 ? '-' : response.images[0].toString();
        images_v2 = response.images_v2;
        videos = response.videos;
        videos.length != 0
            ? _getMetadata(videos[0]['videoUrl'])
            : videos.clear();

        province = response.province["name"].toString();
        latitude = response.meetingPoint["latitude"].toString();
        longitude = response.meetingPoint["longitude"].toString();
        productHighlight = response.productHighlight;
        productCategory = response.productCategory.length == 0
            ? '-'
            : response.productCategory[0]["category"]["name"].toString();
        price = response.price.toString();
        priceCurrency = response.priceCurrency.toString();
        productDescription = response.productDescription.toString();
        createdAt = response.dateCreated.toString();
        blackOutDate = response.blackOutDate;
        for (int i = 0; i < blackOutDate.length; i++) {
          blackOutDateData.add(blackOutDate[i]['date']);
        }
        participant = response.participant.toString();
        notParticipant = response.notParticipant.toString();
        requirements = response.requirements.toString();
        capacity = response.capacity.toString();
        facility = response.facility.toString();
        validityStart = response.validityStart.toString();
        validityEnd = response.validityEnd.toString();
        ageRangeFrom = response.ageRangeFrom.toString();
        ageRangeTo = response.ageRangeTo.toString();
        status = response.status.toString();

        for (int i = 0; i < response.operationalHours.length; i++) {
          if (response.operationalHours[i]['day'] == 'monday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('monday');
          }

          if (response.operationalHours[i]['day'] == 'tuesday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('tuesday');
          }

          if (response.operationalHours[i]['day'] == 'wednesday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('wednesday');
          }

          if (response.operationalHours[i]['day'] == 'thursday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('thursday');
          }

          if (response.operationalHours[i]['day'] == 'friday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('friday');
          }

          if (response.operationalHours[i]['day'] == 'saturday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('saturday');
          }

          if (response.operationalHours[i]['day'] == 'sunday' &&
              response.operationalHours[i]['from'] != 'OFF') {
            allDay.add('sunday');
          }
        }

        loading = false;

        print(videos);
      });
    });
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    getDetailProductfromApi();

    setState(() {});
    refreshController.refreshCompleted();
  }

  void initState() {
    getDetailProductfromApi();
    super.initState();
  }

  void _getMetadata(String url) async {
    bool _isValid = _getUrlValid(url);
    if (_isValid) {
      Metadata? _metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: Duration(days: 7),
        proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
      );
      debugPrint("URL6 => ${_metadata?.title}");
      debugPrint(_metadata?.desc);
    } else {
      videos.clear();
      debugPrint("URL is not valid");
    }
  }

  bool _getUrlValid(String url) {
    bool _isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return _isUrlValid;
  }

  String videoId = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=c4xjJtfTXl0")!;
  // print(videoId); // BBAyRBTfsOU

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => productList_1()),
        (Route<dynamic> route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == "") {
      latitude = "37.42796133580664";
    }

    if (longitude == "") {
      longitude = "-122.085749655962";
    }

    LatLng destination =
        LatLng(double.parse(latitude), double.parse(longitude));

    CameraPosition _kGooglePlex = CameraPosition(
      target: destination,
      zoom: 14.4746,
    );

    MoneyFormatter fmf = MoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
    // disable rotation
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    void changeScene(int index) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  videoFullScreen(videos[index]['videoUrl'].toString())),
          (Route<dynamic> route) => false);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: MaterialApp(
          color: whiteColor,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          home: Scaffold(
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
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => productList_1()),
                                    (Route<dynamic> route) => false);
                              },
                              child: header_layout("Product Detail")),
                          SizedBox(
                            height: 20,
                          ),
                          loading == false
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                          color: whiteD5DDE0, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Stack(
                                          children: [
                                            Column(children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                child: Image.network(
                                                  images,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/default_empty.jpg',
                                                      fit: BoxFit.fill,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Text(
                                                            '$province - $productName',
                                                            style:
                                                                TextStyleMontserratW600Blue2_16,
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: productHighlight
                                                                .length ==
                                                            0
                                                        ? Text(
                                                            "-",
                                                            style:
                                                                TextStyleMontserratW500Blue3_16,
                                                            textAlign:
                                                                TextAlign.start,
                                                          )
                                                        : SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        productHighlight
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            index) {
                                                                      return Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                2),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                defaultBlueColor,
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5))),
                                                                        child:
                                                                            Text(
                                                                          "#" +
                                                                              productHighlight[index]["highlight"],
                                                                          style:
                                                                              TextStyleMontserratW500White_13,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        productCategory == ''
                                                            ? '-'
                                                            : productCategory,
                                                        style:
                                                            TextStyleMontserratW600Blue2_15,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            defaultBlue2Color,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Price',
                                                              style:
                                                                  TextStyleMontserratW600White_13,
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
                                                              "$priceCurrency " +
                                                                  fmf
                                                                      .copyWith(
                                                                        amount:
                                                                            double.parse(price),
                                                                      )
                                                                      .output
                                                                      .withoutFractionDigits,
                                                              style:
                                                                  TextStyleMontserratW600White_15,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Description',
                                                        style:
                                                            TextStyleMontserratW600Blue3_13,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Text(
                                                          '$productDescription',
                                                          style:
                                                              TextStyleMontserratW500Blue3_13,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                whiteD5DDE0)),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <
                                                                    Widget>[
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .close_rounded,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              defaultBlueColor,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          'More Information',
                                                                          style:
                                                                              TextStyleMontserratW500Blue2_15,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(7),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            whiteColor,
                                                                        border: Border.all(
                                                                            color:
                                                                                whiteD5DDE0,
                                                                            width:
                                                                                1),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Category',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$productCategory',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Peserta Dianjurkan ',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$participant',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Peserta Tidak Dianjurkan ',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$notParticipant',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Syarat Khusus (Opsional)',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$requirements',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Kapasitas',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$capacity',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Fasilitas Pendukung',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$facility',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Usia',
                                                                              style: TextStyleMontserratW600Blue3_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                '$ageRangeFrom tahun - $ageRangeTo tahun',
                                                                                style: TextStyleMontserratW500Blue2_13,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'See More >',
                                                          style:
                                                              TextStyleMontserratW600Blue3_13,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                            Positioned(
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: status == "ACTIVE"
                                                        ? green28B710
                                                        : status ==
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
                                                  status == "ACTIVE"
                                                      ? "Active"
                                                      : status ==
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
                                    ],
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: whiteDDDDDD,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: blackColor, width: 1)),
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
                          SizedBox(
                            height: 20,
                          ),
                          loading == false
                              ? InkWell(
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
                                                        ' Meeting Point',
                                                        style:
                                                            TextStyleMontserratW500Blue2_15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      border: Border.all(
                                                          color: whiteD5DDE0,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: GoogleMap(
                                                    mapType: MapType.hybrid,
                                                    initialCameraPosition:
                                                        _kGooglePlex,
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) {
                                                      _controller
                                                          .complete(controller);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      border: Border.all(
                                                          color: whiteD5DDE0,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(7),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                defaultBlueColor,
                                                            border: Border.all(
                                                                color:
                                                                    whiteD5DDE0,
                                                                width: 1),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "8°20′06″S 115°0.5′17″E",
                                                              style:
                                                                  TextStyleMontserratW600White_15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Country',
                                                                  style:
                                                                      TextStyleMontserratW600Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Text(
                                                                  'Indonesia',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
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
                                                                Text(
                                                                  'Province',
                                                                  style:
                                                                      TextStyleMontserratW600Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Text(
                                                                  'Bali',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
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
                                                                Text(
                                                                  'City',
                                                                  style:
                                                                      TextStyleMontserratW600Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Text(
                                                                  'Denpasar',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
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
                                                                Text(
                                                                  'Time Zone',
                                                                  style:
                                                                      TextStyleMontserratW600Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Text(
                                                                  'UTC+08 (WITA)',
                                                                  style:
                                                                      TextStyleMontserratW500Blue3_13,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: defaultBlueColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              size: 20,
                                              color: whiteColor,
                                            ),
                                            Text(
                                              'Meeting Point',
                                              style:
                                                  TextStyleMontserratW600White_17,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: whiteDDDDDD,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: blackColor, width: 1)),
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
                          SizedBox(
                            height: 20,
                          ),
                          loading == false
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                          color: whiteD5DDE0, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Validity',
                                                    style:
                                                        TextStyleMontserratW600Blue3_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            defaultBlue2Color,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          validityStart
                                                                  .substring(
                                                                      0, 10) +
                                                              ' - ' +
                                                              validityEnd
                                                                  .substring(
                                                                      0, 10),
                                                          style:
                                                              TextStyleMontserratW600White_17,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Created at',
                                                    style:
                                                        TextStyleMontserratW600Blue3_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    createdAt.substring(0, 10),
                                                    style:
                                                        TextStyleMontserratW500Blue2_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Black Out Dates',
                                                    style:
                                                        TextStyleMontserratW600Blue3_15,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: blackOutDateData
                                                                .length ==
                                                            0
                                                        ? Text(
                                                            "-",
                                                            style:
                                                                TextStyleMontserratW500Blue3_16,
                                                            textAlign:
                                                                TextAlign.start,
                                                          )
                                                        : SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        blackOutDateData
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            index) {
                                                                      return Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                2),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                        child:
                                                                            Text(
                                                                          blackOutDateData[
                                                                              index],
                                                                          style:
                                                                              TextStyleMontserratW500White_13,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Operational Hour',
                                                        style:
                                                            TextStyleMontserratW600Blue3_15,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 200,
                                                    child: allDay.length == 0
                                                        ? Center(
                                                            child: Text(
                                                              "off",
                                                              style:
                                                                  TextStyleMontserratW600Blue3_17,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )
                                                        : GridView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  200,
                                                              crossAxisSpacing:
                                                                  5,
                                                              childAspectRatio:
                                                                  2.5,
                                                            ),
                                                            itemCount:
                                                                allDay.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        ctx,
                                                                    index) {
                                                              return Stack(
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/images/ProductList/card_${allDay[index]}.png',
                                                                    height: 55,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${allDay[index]}',
                                                                              style: TextStyleMontserratW600card_monday_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '01:00 - 22:30',
                                                                              style: TextStyleMontserratW500card_monday_13,
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                  )
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: whiteDDDDDD,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: blackColor, width: 1)),
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
                          SizedBox(
                            height: 20,
                          ),
                          loading == false
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: whiteD5DDE0, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Product Photo',
                                                style:
                                                    TextStyleMontserratW600Blue3_15,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: images_v2.length == 0
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'No Images',
                                                            style:
                                                                TextStyleMontserratW600Blue3_15,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      )
                                                    : SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: images_v2
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    index) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  child: Image
                                                                      .network(
                                                                    images_v2[
                                                                            index]
                                                                        ['url'],
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            exception,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'No Images',
                                                                            style:
                                                                                TextStyleMontserratW600Blue3_15,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 77,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Product Video',
                                                style:
                                                    TextStyleMontserratW600Blue3_15,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: videos.length == 0
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'No Videos',
                                                            style:
                                                                TextStyleMontserratW600Blue3_15,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      )
                                                    : SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                videos.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    index) {
                                                              YoutubePlayerController
                                                                  _youtubeController =
                                                                  YoutubePlayerController(
                                                                initialVideoId: YoutubePlayer.convertUrlToId(
                                                                    videos[index]
                                                                            [
                                                                            'videoUrl']
                                                                        .toString())!,
                                                                flags:
                                                                    YoutubePlayerFlags(
                                                                  autoPlay:
                                                                      false,
                                                                ),
                                                              );

                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        YoutubePlayerBuilder(
                                                                            player:
                                                                                YoutubePlayer(
                                                                              controller: _youtubeController,
                                                                              thumbnail: videos[index]['thumbnail'] == null
                                                                                  ? Image.asset(
                                                                                      'assets/images/default_empty.jpeg',
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      height: MediaQuery.of(context).size.height,
                                                                                      fit: BoxFit.fill,
                                                                                    )
                                                                                  : Image.network(
                                                                                      videos[index]['thumbnail'].toString(),
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      height: MediaQuery.of(context).size.height,
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                              showVideoProgressIndicator: true,
                                                                            ),
                                                                            builder:
                                                                                (a, player) {
                                                                              return Column(
                                                                                children: [
                                                                                  // some widgets
                                                                                  player,
                                                                                  //some other widgets
                                                                                ],
                                                                              );
                                                                            }),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            changeScene(index);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(30),
                                                                            child:
                                                                                Text(''),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: whiteDDDDDD,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: blackColor, width: 1)),
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
                          SizedBox(
                            height: 20,
                          ),
                          loading == false
                              ? InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                edit_product_1()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: whiteDDDDDD),
                                        color: whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Edit',
                                              style:
                                                  TextStyleMontserratW600Blue3_17,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 15,
                          ),
                          loading == false
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detactive_product_1()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Request Deactivate Product',
                                              style:
                                                  TextStyleMontserratW600White_17,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ])))),
    );
  }
}
