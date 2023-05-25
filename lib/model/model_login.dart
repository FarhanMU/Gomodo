class model_login {
  final int statusCode;

  const model_login({
    required this.statusCode,
  });

  factory model_login.fromJson(Map<String, dynamic> json) {
    return model_login(
      statusCode: json['statusCode'],
    );
  }
}
