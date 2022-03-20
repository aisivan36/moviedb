class ImageBackdrop {
  final String image;
  ImageBackdrop({
    required this.image,
  });
  factory ImageBackdrop.fromJson(Map<String, dynamic> json) {
    return ImageBackdrop(
      image: "https://image.tmdb.org/t/p/original" + json['file_path'],
    );
  }
}

class ImageBackdropList {
  final List<ImageBackdrop> backdrops;

  ImageBackdropList({
    required this.backdrops,
  });

  factory ImageBackdropList.fromJson(List<dynamic> backdrops) {
    return ImageBackdropList(
      backdrops: backdrops
          .map((backdrop) => ImageBackdrop.fromJson(backdrop))
          .toList(),
    );
  }
}
