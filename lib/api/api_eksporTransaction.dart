import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_eksporTransaction.dart';
import 'package:gomodo_mobile/model/model_login.dart';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_eksporTransaction {
  static Future eksporTransaction() async {
    // await Future.delayed(const Duration(seconds: 5), () {});

    http.Response response = await http.post(
      Uri.parse(baseUrl + eksportTransactionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + box.read("access_token"),
      },
    );

    // print("edewww");

    // print(jsonDecode(response.body));
    return model_eksporTransaction.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
