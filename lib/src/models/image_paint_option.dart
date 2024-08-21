class ImagePaintOption {
  final double x;
  final double y;
  final double height;
  final QuestionImage image;
  final bool isCorrect;

  ImagePaintOption(
      {required this.x,
      required this.y,
      required this.height,
      required this.image,
      required this.isCorrect});

  factory ImagePaintOption.fromJson(Map<String, dynamic> json) {
    if (json['x'] == null ||
        json['x'] is! double ||
        json['y'] == null ||
        json['y'] is! double ||
        json['height'] == null ||
        json['height'] is! double ||
        json['image'] == null) {
      throw const FormatException(
          'Invalid or missing "someProperty" in ImagePaintOption');
    }

    return ImagePaintOption(
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
        height: json['height'].toDouble(),
        image: QuestionImage.fromName(json['image']),
        isCorrect: json['isCorrect'] as bool);
  }
}

enum QuestionImage {
  unknown('unknown', 'assets/images/avatar_dog.jpeg'),
  fish('fish', 'assets/images/question_fish.png'),
  dog('dog', 'assets/images/question_dog.png'),
  book('book', 'assets/images/question_book.png'),
  ball('ball', 'assets/images/question_ball.png'),
  tree('tree', 'assets/images/question_tree.png'),
  plant('plant', 'assets/images/question_plant.png'),
  cat('cat', 'assets/images/question_cat.png'),
  goldfish('goldfish', 'assets/images/question_goldfish.png'),
  camel('camel', 'assets/images/question_camel.png'),
  deer('deer', 'assets/images/question_deer.png'),
  toucan('toucan', 'assets/images/question_toucan.png'),
  octopus('octopus', 'assets/images/question_octopus.png'),
  flower('flower', 'assets/images/question_flower.png');

  final String name;
  final String imagePath;

  const QuestionImage(this.name, this.imagePath);

  static QuestionImage fromName(String name) {
    return QuestionImage.values
        .firstWhere((image) => image.name == name, orElse: () => unknown);
  }
}
