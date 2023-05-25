class model_getTransactionDetail {
  final int transactionId;
  final List<dynamic> orderDetail;
  final Map<String, dynamic> product;
  final Map<String, dynamic> business;
  final Map<String, dynamic> customer;
  final Map<String, dynamic> reseller;
  final String dateCreated;
  final String status;
  final List<dynamic> payment;
  final String specialNotes;

  model_getTransactionDetail.fromJson(Map json)
      : transactionId = json["data"]['transactionId'] == null
            ? "-"
            : json["data"]['transactionId'],
        orderDetail = json["data"]['orderDetail'] == null
            ? "-"
            : json["data"]['orderDetail'],
        product =
            json["data"]['product'] == null ? "-" : json["data"]['product'],
        business =
            json["data"]['business'] == null ? "-" : json["data"]['business'],
        customer =
            json["data"]['customer'] == null ? "-" : json["data"]['customer'],
        reseller =
            json["data"]['reseller'] == null ? "-" : json["data"]['reseller'],
        dateCreated = json["data"]['dateCreated'] == null
            ? "-"
            : json["data"]['dateCreated'],
        status = json["data"]['status'] == null ? "-" : json["data"]['status'],
        payment =
            json["data"]['payment'] == null ? "-" : json["data"]['payment'],
        specialNotes = json["data"]['specialNotes'] == null
            ? "-"
            : json["data"]['specialNotes'];

  Map toJson() {
    return {
      'transactionId': transactionId,
      'orderDetail': orderDetail,
      'product': product,
      'business': business,
      'customer': customer,
      'reseller': reseller,
      'dateCreated': dateCreated,
      'status': status,
      'payment': payment,
      'specialNotes': specialNotes,
    };
  }
}
