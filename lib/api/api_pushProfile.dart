import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_pushProfile.dart';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_pushProfile {
  static Future pushProfile(
      String idCardNum,
      String bankName,
      String bankAccountNumber,
      String bankAccountName,
      String profilePicture) async {
    Map data = {
      'idCardNum': idCardNum,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'profilePicture': profilePicture,
    };

    String body = json.encode(data);

    // await Future.delayed(const Duration(seconds: 5), () {});

    http.Response response = await http.patch(
      Uri.parse(baseUrl + updateProfileUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + box.read("access_token"),
      },
      body: body,
    );

    print("adaww");

    print(jsonDecode(response.body));
    return model_pushProfile.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
