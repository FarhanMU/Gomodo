class model_getProvince {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  model_getProvince.fromJson(Map json)
      : id = json['id'] == null ? "-" : json['id'],
        name = json['name'] == null ? "-" : json['name'],
        createdAt = json['createdAt'] == null ? "-" : json['createdAt'],
        updatedAt = json['updatedAt'] == null ? "-" : json['updatedAt'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
