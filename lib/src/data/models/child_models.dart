class Child {
  final String childId;
  final String name;
  final String gender;
  final DateTime dob;
  final int favColour;
  final int favAnimal;

  Child({
    required this.childId,
    required this.name,
    required this.gender,
    required this.dob,
    required this.favColour,
    required this.favAnimal,
  });

  Child copyWith({
    String? childId,
    String? name,
    String? gender,
    DateTime? dob,
    int? favColour,
    int? favAnimal,
  }) {
    return Child(
      childId: childId ?? this.childId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      favColour: favColour ?? this.favColour,
      favAnimal: favAnimal ?? this.favAnimal,
    );
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      dob: DateTime.parse(json['dob'] as String),
      favColour: json['favColour'] as int,
      favAnimal: json['favAnimal'] as int,
    );
  }
}

class ChildCreate {
  final String parentId;
  final String name;
  final String gender;
  final DateTime dob;
  final int favColour;
  final int favAnimal;

  ChildCreate({
    required this.parentId,
    required this.name,
    required this.gender,
    required this.dob,
    required this.favColour,
    required this.favAnimal,
  });

  Map<String, dynamic> toJson() {
    return {
      'parentId': parentId,
      'name': name,
      'gender': gender,
      'dob': dob.toIso8601String().split('T').first,
      'favColour': favColour,
      'favAnimal': favAnimal,
    };
  }
}
