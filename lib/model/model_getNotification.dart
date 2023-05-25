class model_getNotification {
  final int id;
  final int notificationTypeId;
  final int userId;
  final int isRead;
  final int transactionId;
  final int productId;
  final String title;
  final String message;
  final String createdAt;
  final String updatedAt;

  model_getNotification.fromJson(Map json)
      : id = json['id'] == null ? 0 : json['id'],
        notificationTypeId =
            json['notificationTypeId'] == null ? 0 : json['notificationTypeId'],
        userId = json['userId'] == null ? 0 : json['userId'],
        isRead = json['isRead'] == null ? 0 : json['isRead'],
        transactionId =
            json['transactionId'] == null ? 0 : json['transactionId'],
        productId = json['productId'] == null ? 0 : json['productId'],
        title = json['title'] == null ? "-" : json['title'],
        message = json['message'] == null ? "-" : json['message'],
        createdAt = json['createdAt'] == null ? "-" : json['createdAt'],
        updatedAt = json['updatedAt'] == null ? "-" : json['updatedAt'];

  Map toJson() {
    return {
      id: id,
      notificationTypeId: notificationTypeId,
      userId: userId,
      isRead: isRead,
      transactionId: transactionId,
      productId: productId,
      title: title,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
    };
  }
}
