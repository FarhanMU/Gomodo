class model_pushNotification {
  final int statusCode;

  const model_pushNotification({
    required this.statusCode,
  });

  factory model_pushNotification.fromJson(Map<String, dynamic> json) {
    return model_pushNotification(
      statusCode: json['statusCode'],
    );
  }
}
