class model_getProfile {
  final int id;
  final int userId;
  final int businessId;
  final String ownerName;
  final String ownerAddress;
  final String idCardNum;
  final String createdAt;
  final String updatedAt;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountName;
  final Map<String, dynamic> business;
  final Map<String, dynamic> user;

  model_getProfile.fromJson(Map json)
      : id = json['data']['id'] == null ? 0 : json['data']['id'],
        userId = json['data']['userId'] == null ? 0 : json['data']['userId'],
        businessId =
            json['data']['businessId'] == null ? 0 : json['data']['businessId'],
        ownerName =
            json['data']['ownerName'] == null ? "-" : json['data']['ownerName'],
        ownerAddress = json['data']['ownerAddress'] == null
            ? "-"
            : json['data']['ownerAddress'],
        idCardNum =
            json['data']['idCardNum'] == null ? "-" : json['data']['idCardNum'],
        createdAt =
            json['data']['createdAt'] == null ? "-" : json['data']['createdAt'],
        updatedAt =
            json['data']['updatedAt'] == null ? "-" : json['data']['updatedAt'],
        bankName = json['data']['user']['paymentAccount']['bankName'] == null
            ? "-"
            : json['data']['user']['paymentAccount']['bankName'],
        bankAccountNumber =
            json['data']['user']['paymentAccount']['accountNo'] == null
                ? "-"
                : json['data']['user']['paymentAccount']['accountNo'],
        bankAccountName =
            json['data']['user']['paymentAccount']['accountName'] == null
                ? "-"
                : json['data']['user']['paymentAccount']['accountName'],
        business =
            json['data']['business'] == null ? "-" : json['data']['business'],
        user = json['data']['user'] == null ? "-" : json['data']['user'];

  Map toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'ownerName': ownerName,
      'ownerAddress': ownerAddress,
      'idCardNum': idCardNum,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'business': business,
      'user': user,
    };
  }
}
