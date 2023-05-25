import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/api/api_pushNotification.dart';
import 'package:gomodo_mobile/model/model_getNotification.dart';
import 'package:gomodo_mobile/page/add_product_1.dart';
import 'package:gomodo_mobile/page/add_product_2.dart';
import 'package:gomodo_mobile/page/add_product_3.dart';
import 'package:gomodo_mobile/page/dashboard_1.dart';
import 'package:gomodo_mobile/page/dashboard_2.dart';
import 'package:gomodo_mobile/page/detactive_product_1.dart';
import 'package:gomodo_mobile/page/login_1.dart';
import 'package:gomodo_mobile/page/login_2.dart';
import 'package:gomodo_mobile/page/login_4.dart';
import 'package:gomodo_mobile/page/productList_1.dart';
import 'package:gomodo_mobile/page/productList_2.dart';
import 'package:gomodo_mobile/page/profile_1.dart';
import 'package:gomodo_mobile/page/register_1.dart';
import 'package:gomodo_mobile/page/register_2.dart';
import 'package:gomodo_mobile/page/register_3.dart';
import 'package:gomodo_mobile/page/transactionList_1.dart';
import 'package:gomodo_mobile/page/welcomeScreen_1.dart';
import 'package:gomodo_mobile/page/welcomeScreen_2.dart';
import 'package:gomodo_mobile/untilities/norifi_service.dart';
import 'package:gomodo_mobile/untilities/theme.dart';
import 'package:status_bar_control/status_bar_control.dart';

import 'api/api_getNotification.dart';
import 'untilities/test_video.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<model_getNotification> getNotification = [];
  void getNotificationsfromApi() async {
    api_getNotification.getNotification().then((response) {
      setState(() {
        // Iterable list = response;
        // getNotification =
        //     list.map((model) => model_getNotification.fromJson(model)).toList();
        for (int i = 0; i < response.length; i++) {
          // print(response[i]['message']);
          if (response[i]['isRead'] == 0) {
            NotificationService().showNotification(
                title: response[i]['title'],
                body: response[i]['message'],
                id: response[i]['notificationTypeId']);
            StatusBarControl.setColor(defaultBlueColor.withOpacity(1),
                animated: true);
            // delayGetData();
          }
        }
      });
    });
  }

  int responsestatusCode = 0;

  // void delayGetData() async {
  //   await Future.delayed(Duration(minutes: 60));
  //   getNotificationsfromApi();
  // }

  @override
  void initState() {
    getNotificationsfromApi();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => welcomeScreen_1(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
