class TrailerModel {
  final String id;
  final String site;
  final String name;
  final String key;
  TrailerModel({
    required this.id,
    required this.site,
    required this.name,
    required this.key,
  });
  factory TrailerModel.fromJson(Map<String, dynamic> json) {
    return TrailerModel(
      key: json['key'] ?? '',
      id: json['id'] ?? '',
      site: json['site'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TrailerList {
  final List<TrailerModel> trailers;
  TrailerList({
    required this.trailers,
  });
  factory TrailerList.fromJson(json) {
    return TrailerList(
        trailers: json != null
            ? (json['results'] as List)
                .map((trailer) => TrailerModel.fromJson(trailer))
                .toList()
            : []);
  }
}
