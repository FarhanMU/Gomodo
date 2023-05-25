class model_getproductDetail {
  final String productName;
  final String merchantName;
  final String productDescription;
  final List<dynamic> images;
  final List<dynamic> images_v2;
  final List<dynamic> videos;
  final List<dynamic> operationalHours;
  final List<dynamic> blackOutDate;
  final Map<String, dynamic> meetingPoint;
  final int price;
  final String priceCurrency;
  final String validityStart;
  final String validityEnd;
  final String participant;
  final String notParticipant;
  final String requirements;
  final int capacity;
  final String facility;
  final int ageRangeFrom;
  final int ageRangeTo;
  final String status;
  final String cityName;
  final String placeName;
  final String dateCreated;
  final List<dynamic> productHighlight;
  final List<dynamic> productCategory;
  final Map<String, dynamic> province;
  final Map<String, dynamic> merchant;

  model_getproductDetail.fromJson(Map json)
      : productName = json["data"]['productName'] == null
            ? "-"
            : json["data"]['productName'],
        merchantName = json["data"]['merchantName'] == null
            ? "-"
            : json["data"]['merchantName'],
        productDescription = json["data"]['productDescription'] == null
            ? "-"
            : json["data"]['productDescription'],
        images = json["data"]['images'] == null ? "-" : json["data"]['images'],
        images_v2 =
            json["data"]['images_v2'] == null ? "-" : json["data"]['images_v2'],
        videos = json["data"]['videos'] == null ? [] : json["data"]['videos'],
        operationalHours = json["data"]['operationalHours'] == null
            ? "-"
            : json["data"]['operationalHours'],
        meetingPoint = json["data"]['meetingPoint'] == null
            ? "-"
            : json["data"]['meetingPoint'],
        price = json["data"]['price'] == null ? "-" : json["data"]['price'],
        priceCurrency = json["data"]['priceCurrency'] == null
            ? "-"
            : json["data"]['priceCurrency'],
        validityStart = json["data"]['validityStart'] == null
            ? "2023-05-18T00:00:00.000Z"
            : json["data"]['validityStart'],
        validityEnd = json["data"]['validityEnd'] == null
            ? "2023-05-26T00:00:00.000Z"
            : json["data"]['validityEnd'],
        blackOutDate = json["data"]['blackOutDate'] == null
            ? "-"
            : json["data"]['blackOutDate'],
        participant = json["data"]['participant'] == null
            ? "-"
            : json["data"]['participant'],
        notParticipant = json["data"]['notParticipant'] == null
            ? "-"
            : json["data"]['notParticipant'],
        requirements = json["data"]['requirements'] == null
            ? "-"
            : json["data"]['requirements'],
        capacity =
            json["data"]['capacity'] == null ? 0 : json["data"]['capacity'],
        facility =
            json["data"]['facility'] == null ? "-" : json["data"]['facility'],
        ageRangeFrom = json["data"]['ageRangeFrom'] == null
            ? 0
            : json["data"]['ageRangeFrom'],
        ageRangeTo =
            json["data"]['ageRangeTo'] == null ? 0 : json["data"]['ageRangeTo'],
        status = json["data"]['status'] == null ? "-" : json["data"]['status'],
        cityName =
            json["data"]['cityName'] == null ? "-" : json["data"]['cityName'],
        placeName =
            json["data"]['placeName'] == null ? "-" : json["data"]['placeName'],
        dateCreated = json["data"]['dateCreated'] == null
            ? "-"
            : json["data"]['dateCreated'],
        productHighlight = json["data"]['productHighlight'] == null
            ? "-"
            : json["data"]['productHighlight'],
        productCategory = json["data"]['productCategory'] == null
            ? "-"
            : json["data"]['productCategory'],
        province =
            json["data"]['province'] == null ? "-" : json["data"]['province'],
        merchant =
            json["data"]['merchant'] == null ? "-" : json["data"]['merchant'];

  Map toJson() {
    return {
      'productName': productName,
      'merchantName': merchantName,
      'productDescription': productDescription,
      'images': images,
      'images_v2': images_v2,
      'videos': videos,
      'operationalHours': operationalHours,
      'meetingPoint': meetingPoint,
      'price': price,
      'priceCurrency': priceCurrency,
      'validityStart': validityStart,
      'validityEnd': validityEnd,
      'blackOutDate': blackOutDate,
      'participant': participant,
      'notParticipant': notParticipant,
      'requirements': requirements,
      'capacity': capacity,
      'facility': facility,
      'ageRangeFrom': ageRangeFrom,
      'ageRangeTo': ageRangeTo,
      'status': status,
      'cityName': cityName,
      'placeName': placeName,
      'dateCreated': dateCreated,
      'productHighlight': productHighlight,
      'productCategory': productCategory,
      'province': province,
      'merchant': merchant,
    };
  }
}
