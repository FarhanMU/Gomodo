import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_detactiveReason.dart';
import 'package:gomodo_mobile/model/model_login.dart';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_detactiveReason {
  static Future detactiveReason(
      String deactiveReason, String deactiveDesc, String id) async {
    Map data = {
      'deactiveReason': deactiveReason,
      'deactiveDesc': deactiveDesc,
    };

    String body = json.encode(data);

    // await Future.delayed(const Duration(seconds: 5), () {});

    http.Response response = await http.post(
      Uri.parse(baseUrl + detactiveReasonPushUrl + id),
      headers: {
        'Authorization': 'Bearer ' + box.read("access_token"),
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // print('Bearer ' + box.read("access_token"));

    // print(jsonDecode(response.body));
    return model_detactiveReason.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
