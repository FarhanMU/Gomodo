class model_pushProfile {
  final int statusCode;

  const model_pushProfile({
    required this.statusCode,
  });

  factory model_pushProfile.fromJson(Map<String, dynamic> json) {
    return model_pushProfile(
      statusCode: json['statusCode'],
    );
  }
}
