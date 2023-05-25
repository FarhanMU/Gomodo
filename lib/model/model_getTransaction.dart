class model_getTransaction {
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

  model_getTransaction.fromJson(Map json)
      : transactionId =
            json['transactionId'] == null ? "-" : json['transactionId'],
        orderDetail = json['orderDetail'] == null ? "-" : json['orderDetail'],
        product = json['product'] == null ? "-" : json['product'],
        business = json['business'] == null ? "-" : json['business'],
        customer = json['customer'] == null ? "-" : json['customer'],
        reseller = json['reseller'] == null ? "-" : json['reseller'],
        dateCreated = json['dateCreated'] == null ? "-" : json['dateCreated'],
        status = json['status'] == null ? "-" : json['status'],
        payment = json['payment'] == null ? "-" : json['payment'],
        specialNotes =
            json['specialNotes'] == null ? "-" : json['specialNotes'];

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
