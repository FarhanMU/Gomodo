import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_register.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_register {
  static Future register(
      String email,
      String phoneNumber,
      String ownerName,
      String ownerAddress,
      String idCardNum,
      String bankName,
      String bankAccountNumber,
      String bankAccountName,
      String businessName,
      String businessEmail,
      String businessPhoneNumber,
      String businessType,
      String businessAddress,
      String businessSocMedInstagram,
      String businessSocMedFacebook,
      int associationId) async {
    Map data = {
      'email': email,
      'phoneNumber': phoneNumber,
      'ownerName': ownerName,
      'ownerAddress': ownerAddress,
      'idCardNum': idCardNum,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'businessName': businessName
      // 'businessEmail': businessEmail,
      // 'businessPhoneNumber': businessPhoneNumber,
      // 'businessType': businessType,
      // 'businessAddress': businessAddress,
      // 'businessSocMedInstagram': businessSocMedInstagram,
      // 'businessSocMedFacebook': businessSocMedFacebook,
      // 'associationId': associationId
    };

    String body = json.encode(data);

    // await Future.delayed(const Duration(seconds: 5), () {});

    http.Response response = await http.post(
      Uri.parse(baseUrl + registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print(jsonDecode(response.body));
    return model_register.fromJson(jsonDecode(response.body));
    // return json.decode(response.body);
  }
}
