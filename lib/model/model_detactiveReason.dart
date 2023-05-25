class model_detactiveReason {
  final String statusCode;

  const model_detactiveReason({
    required this.statusCode,
  });

  factory model_detactiveReason.fromJson(Map<String, dynamic> json) {
    return model_detactiveReason(
      statusCode: json['statusCode'],
    );
  }
}
