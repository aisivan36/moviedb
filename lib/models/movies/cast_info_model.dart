class CastInfo {
  final String name;
  final String character;
  final String image;
  final String id;
  CastInfo({
    required this.name,
    required this.character,
    required this.image,
    required this.id,
  });
  factory CastInfo.fromJson(json) {
    return CastInfo(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      image: json['profile_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['profile_path']
          : "",
    );
  }
}

class CastInfoList {
  final List<CastInfo> castList;
  CastInfoList({
    required this.castList,
  });
  factory CastInfoList.fromJson(Map<String, dynamic> json) {
    return CastInfoList(
      castList: ((json['cast'] ?? []) as List)
          .map((cast) => CastInfo.fromJson(cast))
          .toList(),
    );
  }
}
