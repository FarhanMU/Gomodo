class model_addProduct {
  final int statusCode;

  const model_addProduct({
    required this.statusCode,
  });

  factory model_addProduct.fromJson(Map<String, dynamic> json) {
    return model_addProduct(
      statusCode: json['statusCode'],
    );
  }
}
