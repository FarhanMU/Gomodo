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
import 'package:gomodo_mobile/layout/header_layout_2.dart';
import 'package:gomodo_mobile/model/model_getproduct.dart';
import 'package:gomodo_mobile/model/model_getproductDetail.dart';
import 'package:gomodo_mobile/page/detactive_product_1.dart';
import 'package:gomodo_mobile/page/edit_product_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/productList_2.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/register_3.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class videoFullScreen extends StatefulWidget {
  final String videoUrl;
  const videoFullScreen(this.videoUrl);

  @override
  State<videoFullScreen> createState() => _videoFullScreenState(videoUrl);
}

int _currentSliders = 0;
final CarouselController _controller = CarouselController();

class _videoFullScreenState extends State<videoFullScreen> {
  final String videoUrl;
  _videoFullScreenState(this.videoUrl);

  void initState() {
    super.initState();
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
    YoutubePlayerController _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    return WillPopScope(
        onWillPop: onWillPop,
        child: MaterialApp(
          color: Colors.black,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: false,
                            bottomActions: [
                              // CurrentPosition(),
                              ProgressBar(isExpanded: false),
                            ],
                          ),
                          builder: (context, player) {
                            return Column(
                              children: [
                                // some widgets
                                player,
                                //some other widgets
                              ],
                            );
                          }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => productList_2()),
                              (Route<dynamic> route) => false);
                        },
                        child: header_layout_2("Watching Videos")),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
