import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_getTransactionDetail.dart';
import 'package:gomodo_mobile/model/model_login.dart';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:gomodo_mobile/model/model_getproductDetail.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_getTransactionDetail {
  static Future getTransactionDetail(String id) async {
    // await Future.delayed(const Duration(seconds: 5), () {});

    final http.Response response = await http
        .get(Uri.parse(baseUrl + transactionDetailUrl + id), headers: {
      'Authorization': 'Bearer ' + box.read("access_token"),
      // 'Authorization': 'Bearer ' + adminToken,
    });

    // print(jsonDecode(response.body));
    return model_getTransactionDetail.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
