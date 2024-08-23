import 'package:assess_math/src/config.dart';

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
  fish('fish', '${Config.imagePathPrefix}question_fish.png'),
  dog('dog', '${Config.imagePathPrefix}question_dog.png'),
  book('book', '${Config.imagePathPrefix}question_book.png'),
  ball('ball', '${Config.imagePathPrefix}question_ball.png'),
  tree('tree', '${Config.imagePathPrefix}question_tree.png'),
  plant('plant', '${Config.imagePathPrefix}question_plant.png'),
  cat('cat', '${Config.imagePathPrefix}question_cat.png'),
  goldfish('goldfish', '${Config.imagePathPrefix}question_goldfish.png'),
  camel('camel', '${Config.imagePathPrefix}question_camel.png'),
  deer('deer', '${Config.imagePathPrefix}question_deer.png'),
  toucan('toucan', '${Config.imagePathPrefix}question_toucan.png'),
  octopus('octopus', '${Config.imagePathPrefix}question_octopus.png'),
  flower('flower', '${Config.imagePathPrefix}question_flower.png');

  final String name;
  final String imagePath;

  const QuestionImage(this.name, this.imagePath);

  static QuestionImage fromName(String name) {
    return QuestionImage.values.firstWhere((image) => image.name == name,
        orElse: () => throw FormatException('Image with name $name not found'));
  }
}
