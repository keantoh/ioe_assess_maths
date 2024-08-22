import 'package:math_assessment/src/config.dart';

enum AvatarAnimal {
  dog(1, '${Config.imagePathPrefix}avatar_dog.jpeg'),
  cat(2, '${Config.imagePathPrefix}avatar_cat.jpeg'),
  bird(3, '${Config.imagePathPrefix}avatar_bird.jpeg'),
  elephant(4, '${Config.imagePathPrefix}avatar_elephant.jpeg'),
  lion(5, '${Config.imagePathPrefix}avatar_lion.jpeg'),
  panda(6, '${Config.imagePathPrefix}avatar_panda.jpeg'),
  rabbit(7, '${Config.imagePathPrefix}avatar_rabbit.jpeg');

  final int id;
  final String imagePath;
  final prefix = Config.imagePathPrefix;

  const AvatarAnimal(this.id, this.imagePath);

  static AvatarAnimal fromId(int id) {
    return AvatarAnimal.values
        .firstWhere((avatar) => avatar.id == id, orElse: () => dog);
  }
}
