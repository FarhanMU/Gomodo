class model_getproduct {
  final int productId;
  final String productName;
  final String merchantName;
  final String featuredImage;
  final int priceAmount;
  final String priceCurrency;
  final String status;
  final String merchantPicture;
  final String cityName;
  final String placeName;
  final String dateCreated;
  // final String category;
  // sub province
  final int province_id;
  final String province_name;
  final String province_createdAt;
  final String province_updatedAt;

  model_getproduct.fromJson(Map json)
      : productId = json['productId'] == null ? "-" : json['productId'],
        productName = json['productName'] == null ? "-" : json['productName'],
        merchantName =
            json['merchantName'] == null ? "-" : json['merchantName'],
        featuredImage =
            json['featuredImage'] == null ? "-" : json['featuredImage'],
        priceAmount = json['priceAmount'] == null ? "-" : json['priceAmount'],
        priceCurrency =
            json['priceCurrency'] == null ? "-" : json['priceCurrency'],
        status = json['status'] == null ? "-" : json['status'],
        merchantPicture =
            json['merchantPicture'] == null ? "-" : json['merchantPicture'],
        cityName = json['cityName'] == null ? "-" : json['cityName'],
        placeName = json['placeName'] == null ? "-" : json['placeName'],
        dateCreated = json['dateCreated'] == null ? "-" : json['dateCreated'],
        // category = json['category'] == null ? "-" : json['category'],
        province_id =
            json['province']['id'] == null ? "-" : json['province']['id'],
        province_name =
            json['province']['name'] == null ? "-" : json['province']['name'],
        province_createdAt = json['province']['createdAt'] == null
            ? "-"
            : json['province']['createdAt'],
        province_updatedAt = json['province']['updatedAt'] == null
            ? "-"
            : json['province']['updatedAt'];

  Map toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'merchantName': merchantName,
      'featuredImage': featuredImage,
      'priceAmount': priceAmount,
      'priceCurrency': priceCurrency,
      'status': status,
      'merchantPicture': merchantPicture,
      'cityName': cityName,
      'placeName': placeName,
      'dateCreated': dateCreated,
      // 'category': category,
      'province_id': province_id,
      'province_name': province_name,
      'province_createdAt': province_createdAt,
      'province_updatedAt': province_updatedAt
    };
  }
}
