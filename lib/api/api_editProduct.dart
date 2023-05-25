import 'dart:async';
import 'dart:convert';
import 'package:gomodo_mobile/model/model_addProduct.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gomodo_mobile/layout/baseUrl.dart';
import 'package:gomodo_mobile/model/model_editProduct.dart';
import 'package:http/http.dart' as http;

GetStorage box = GetStorage();

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class api_editProduct {
  static Future editProduct(
    String id,
    String productName,
    String productDescription,
    String category,
    String placeName,
    String meetingPointProvince,
    String meetingPointCity,
    String meetingPointAddress,
    List<String> productHighlight, //[]
    String validityStart,
    String validityEnd,
    List<String> blackoutDate, //[]
    List<String> photos, //[]
    List<String> videos, //[]
    List<String> operationalHourFrom, //[mondayFrom]
    List<String> operationalHourTo, //[mondayTo]
    // String productPriceCurrency,
    String productPriceAmount,
    String participant,
    String notParticipant,
    String capacity,
    String facility,
    String requirements,
    String ageRangeFrom,
    String ageRangeTo,
    List<String> videosId, //[]
    List<String> productHighlightID, //[]
    List<String> productPhotoUrlId, //[]
  ) async {
    String operationalHourmondayFrom = '';
    String operationalHourmondayTo = '';
    String operationalHourtuesdayFrom = '';
    String operationalHourtuesdayTo = '';
    String operationalHourwednesdayFrom = '';
    String operationalHourwednesdayTo = '';
    String operationalHourthursdayFrom = '';
    String operationalHourthursdayTo = '';
    String operationalHourfridayFrom = '';
    String operationalHourfridayTo = '';
    String operationalHoursaturdayFrom = '';
    String operationalHoursaturdayTo = '';
    String operationalHoursundayFrom = '';
    String operationalHoursundayTo = '';

    for (int i = 0; i < operationalHourTo.length; i++) {
      if ('operationalHour[mondayTo]' == operationalHourTo[i]) {
        operationalHourmondayTo = operationalHourTo[i];
      }
      if ('operationalHour[tuesdayTo]' == operationalHourTo[i]) {
        operationalHourtuesdayTo = operationalHourTo[i];
      }
      if ('operationalHour[wednesdayTo]' == operationalHourTo[i]) {
        operationalHourwednesdayTo = operationalHourTo[i];
      }
      if ('operationalHour[thursdayTo]' == operationalHourTo[i]) {
        operationalHourthursdayTo = operationalHourTo[i];
      }
      if ('operationalHour[fridayTo]' == operationalHourTo[i]) {
        operationalHourfridayTo = operationalHourTo[i];
      }
      if ('operationalHour[saturdayTo]' == operationalHourTo[i]) {
        operationalHoursaturdayTo = operationalHourTo[i];
      }
      if ('operationalHour[sundayTo]' == operationalHourTo[i]) {
        operationalHoursundayTo = operationalHourTo[i];
      }
    }

    for (int i = 0; i < operationalHourFrom.length; i++) {
      if ('operationalHour[mondayFrom]' == operationalHourFrom[i]) {
        operationalHourmondayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[tuesdayFrom]' == operationalHourFrom[i]) {
        operationalHourtuesdayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[wednesdayFrom]' == operationalHourFrom[i]) {
        operationalHourwednesdayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[thursdayFrom]' == operationalHourFrom[i]) {
        operationalHourthursdayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[fridayFrom]' == operationalHourFrom[i]) {
        operationalHourfridayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[saturdayFrom]' == operationalHourFrom[i]) {
        operationalHoursaturdayFrom = operationalHourFrom[i];
      }
      if ('operationalHour[sundayFrom]' == operationalHourFrom[i]) {
        operationalHoursundayFrom = operationalHourFrom[i];
      }
    }

    participant == '' ? 'tidak ada data' : participant;
    notParticipant == '' ? 'tidak ada data' : notParticipant;
    capacity == '' ? '0' : capacity;
    facility == '' ? 'tidak ada data' : facility;
    requirements == '' ? 'tidak ada data' : requirements;
    ageRangeFrom == '' ? '0' : ageRangeFrom;
    ageRangeTo == '' ? '0' : ageRangeTo;

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['category'] = category;
    data['placeName'] = placeName;
    data['meetingPointProvince'] = meetingPointProvince;
    data['meetingPointCity'] = meetingPointCity;
    data['meetingPointAddress'] = meetingPointAddress;
    data['productPriceAmount'] = productPriceAmount;
    data['productPriceCurrency'] = 'IDR';
    data['meetingPointCoordinateX'] = box.read('lattitude').toString();
    data['meetingPointCoordinateY'] = box.read('longitude').toString();
    data['participant'] = participant == '' ? 'tidak ada data' : participant;
    data['notParticipant'] =
        notParticipant == '' ? 'tidak ada data' : notParticipant;
    data['capacity'] = capacity == '' ? '0' : capacity;
    data['facility'] = facility == '' ? 'tidak ada data' : facility;
    data['ageRangeFrom'] = ageRangeFrom == '' ? '0' : ageRangeFrom;
    data['ageRangeTo'] = ageRangeTo == '' ? '0' : ageRangeTo;
    data['validityStart'] = validityStart;
    data['validityEnd'] = validityEnd;

    for (int i = 0; i < productHighlight.length; i++) {
      data['productHighlight[$i]'] = productHighlight[i];
    }
    // productHighlightID

    for (int i = 0; i < blackoutDate.length; i++) {
      data[blackoutDate.length == 0 ? '' : 'blackoutDate[$i]'] =
          blackoutDate[i];
    }
    for (int i = 0; i < photos.length; i++) {
      data['newPhotos[$i]'] = photos[i];
    }

    for (int i = 0; i < productPhotoUrlId.length; i++) {
      data['deletePhotos[$i]'] = productPhotoUrlId[i];
    }

    for (int i = 0; i < videosId.length; i++) {
      data['deleteVideos[$i]'] = videosId[i];
    }

    for (int i = 0; i < videos.length; i++) {
      data['newVideos[$i]'] = videos[i];
    }
    data[operationalHourmondayFrom] = box.read('mondayTimeFrom');
    data[operationalHourmondayTo] = box.read('mondayTimeTo');
    data[operationalHourtuesdayFrom] = box.read('tuesdayTimeFrom');
    data[operationalHourtuesdayTo] = box.read('tuesdayTimeTo');
    data[operationalHourwednesdayFrom] = box.read('wednesdayTimeFrom');
    data[operationalHourwednesdayTo] = box.read('wednesdayTimeTo');
    data[operationalHourthursdayFrom] = box.read('thursdayTimeFrom');
    data[operationalHourthursdayTo] = box.read('thursdayTimeTo');
    data[operationalHourfridayFrom] = box.read('fridayTimeFrom');
    data[operationalHourfridayTo] = box.read('fridayTimeTo');
    data[operationalHoursaturdayFrom] = box.read('saturdayTimeFrom');
    data[operationalHoursaturdayTo] = box.read('saturdayTimeTo');
    data[operationalHoursundayFrom] = box.read('sundayTimeFrom');
    data[operationalHoursundayTo] = box.read('sundayTimeTo');

    final response = await http.patch(
      Uri.parse(baseUrl + editProductUrl + id),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer ' + box.read("access_token"),
      },
      encoding: Encoding.getByName('utf-8'),
      // body: json.encode(data),
      body: data,
    );
    print(jsonDecode(response.body));
    print(response.statusCode);
    // print(photos[0]);

    return model_editProduct.fromJson(jsonDecode(response.body));

    // if (response.statusCode == 201) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    // }
  }
}
