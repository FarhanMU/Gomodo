class model_loseAccessToPhone {
  final int statusCode;

  const model_loseAccessToPhone({
    required this.statusCode,
  });

  factory model_loseAccessToPhone.fromJson(Map<String, dynamic> json) {
    return model_loseAccessToPhone(
      statusCode: json['statusCode'],
    );
  }
}
