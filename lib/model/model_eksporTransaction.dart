class model_eksporTransaction {
  final String url;

  const model_eksporTransaction({
    required this.url,
  });

  factory model_eksporTransaction.fromJson(Map<String, dynamic> json) {
    return model_eksporTransaction(
      url: json["data"]['url'],
    );
  }
}
