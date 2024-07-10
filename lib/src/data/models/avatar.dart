enum Avatar { dog, cat, bird, bird2, bird3, bird4 }

String getAvatarImagePath(Avatar avatar) {
  switch (avatar) {
    case Avatar.dog:
      return 'assets/images/avatar_dog.jpeg';
    case Avatar.cat:
      return 'assets/images/avatar_cat.jpeg';
    default:
      return 'assets/images/avatar_bird.jpeg';
  }
}
