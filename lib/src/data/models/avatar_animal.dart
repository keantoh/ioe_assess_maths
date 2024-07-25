enum AvatarAnimal {
  dog(1, 'assets/images/avatar_dog.jpeg'),
  cat(2, 'assets/images/avatar_cat.jpeg'),
  bird(3, 'assets/images/avatar_bird.jpeg'),
  bird2(4, 'assets/images/avatar_bird.jpeg'),
  bird3(5, 'assets/images/avatar_bird.jpeg'),
  bird4(6, 'assets/images/avatar_bird.jpeg');

  final int id;
  final String imagePath;

  const AvatarAnimal(this.id, this.imagePath);
}
