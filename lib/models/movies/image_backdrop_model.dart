class ImageBackdrop {
  final String image;
  ImageBackdrop({
    required this.image,
  });
  factory ImageBackdrop.fromJson(json) {
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

  factory ImageBackdropList.fromJson(backdrops) {
    return ImageBackdropList(
      backdrops: (backdrops as List)
          .map((backdrop) => ImageBackdrop.fromJson(backdrop))
          .toList(),
    );
  }
}
