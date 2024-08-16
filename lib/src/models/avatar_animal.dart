enum AvatarAnimal {
  dog(1, 'assets/images/avatar_dog.jpeg'),
  cat(2, 'assets/images/avatar_cat.jpeg'),
  bird(3, 'assets/images/avatar_bird.jpeg'),
  elephant(4, 'assets/images/avatar_elephant.jpeg'),
  lion(5, 'assets/images/avatar_lion.jpeg'),
  panda(6, 'assets/images/avatar_panda.jpeg'),
  rabbit(7, 'assets/images/avatar_rabbit.jpeg');

  final int id;
  final String imagePath;

  const AvatarAnimal(this.id, this.imagePath);

  static AvatarAnimal fromId(int id) {
    return AvatarAnimal.values
        .firstWhere((avatar) => avatar.id == id, orElse: () => dog);
  }
}
