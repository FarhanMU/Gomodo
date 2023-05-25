import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_getProfile.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_getProfile {
  static Future getProfile() async {
    // await Future.delayed(const Duration(seconds: 5), () {});

    final http.Response response =
        await http.get(Uri.parse(baseUrl + profileUrl), headers: {
      'Authorization': 'Bearer ' + box.read("access_token"),
    });

    print(jsonDecode(response.body));
    return model_getProfile.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
