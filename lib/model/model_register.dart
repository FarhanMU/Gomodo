class model_register {
  final int statusCode;
  final String message;

  const model_register({
    required this.statusCode,
    required this.message,
  });

  factory model_register.fromJson(Map<String, dynamic> json) {
    return model_register(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
