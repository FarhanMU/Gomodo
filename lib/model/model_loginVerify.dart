class model_loginVerify {
  final bool isVerify;
  final String access_token;
  final String msg;
  final int statusCode;

  const model_loginVerify({
    required this.isVerify,
    required this.access_token,
    required this.msg,
    required this.statusCode,
  });

  factory model_loginVerify.fromJson(Map<String, dynamic> json) {
    return model_loginVerify(
      isVerify: json['isVerify'],
      access_token: json['access_token'],
      msg: json['message'],
      statusCode: json['statusCode'],
    );
  }
}
