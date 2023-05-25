class model_editProduct {
  final int statusCode;

  const model_editProduct({
    required this.statusCode,
  });

  factory model_editProduct.fromJson(Map<String, dynamic> json) {
    return model_editProduct(
      statusCode: json['statusCode'],
    );
  }
}
