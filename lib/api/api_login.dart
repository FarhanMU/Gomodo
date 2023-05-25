import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_login.dart';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_login {
  static Future login(String phone) async {
    Map data = {
      'phone': phone,
    };

    String body = json.encode(data);

    // await Future.delayed(const Duration(seconds: 5), () {});

    http.Response response = await http.post(
      Uri.parse(baseUrl + loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("adaww");

    print(jsonDecode(response.body));
    return model_login.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
