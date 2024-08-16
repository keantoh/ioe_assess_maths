class ImagePaintOption {
  final double x;
  final double y;
  final double width;
  final QuestionImage image;

  ImagePaintOption(
      {required this.x,
      required this.y,
      required this.width,
      required this.image});

  factory ImagePaintOption.fromJson(Map<String, dynamic> json) {
    return ImagePaintOption(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        width: json['width'].toDouble(),
        image: QuestionImage.fromName(json['image']));
  }
}

enum QuestionImage {
  unknown('unknown', 'assets/images/avatar_dog.jpeg'),
  fish('fish', 'assets/images/avatar_dog.jpeg'),
  dog('dog', 'assets/images/avatar_cat.jpeg'),
  book('book', 'assets/images/avatar_bird.jpeg'),
  ball('ball', 'assets/images/avatar_elephant.jpeg'),
  tree('tree', 'assets/images/avatar_lion.jpeg'),
  plant('plant', 'assets/images/avatar_panda.jpeg'),
  cat('cat', 'assets/images/avatar_rabbit.jpeg'),
  goldfish('goldfish', 'assets/images/avatar_rabbit.jpeg'),
  camel('camel', 'assets/images/avatar_rabbit.jpeg'),
  deer('deer', 'assets/images/avatar_rabbit.jpeg'),
  toucan('toucan', 'assets/images/avatar_rabbit.jpeg'),
  octopus('octopus', 'assets/images/avatar_rabbit.jpeg'),
  flower('flower', 'assets/images/avatar_rabbit.jpeg');

  final String name;
  final String imagePath;

  const QuestionImage(this.name, this.imagePath);

  static QuestionImage fromName(String name) {
    return QuestionImage.values
        .firstWhere((image) => image.name == name, orElse: () => unknown);
  }
}
