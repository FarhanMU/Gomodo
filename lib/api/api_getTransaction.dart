import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

class api_getTransaction {
  static Future getTransaction(
      String sortOrder, String sortField, String keyword) async {
    Map<String, dynamic> map;
    List<dynamic> posts = [];

    try {
      // This is an open REST API endpoint for testing purposes
      final http.Response response = await http.get(
          Uri.parse(baseUrl + transactionUrl + sortOrder + sortField + keyword),
          headers: {
            'Authorization': 'Bearer ' + box.read("access_token"),
            // 'Authorization': 'Bearer ' + adminToken,
          });

      map = json.decode(response.body);
      posts = map["data"];
    } catch (err) {
      print(err);
    }
    // print(baseUrl + transactionUrl + sortOrder + sortField + keyword);

    return posts;
  }
}
