class Child {
  final int childId;
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

  Child trimmed() {
    return Child(
        childId: childId,
        name: name.trim(),
        gender: gender,
        dob: dob,
        favColour: favColour,
        favAnimal: favAnimal);
  }

  bool hasChanges(Child other) {
    return childId != other.childId ||
        name != other.name ||
        gender != other.gender ||
        dob != other.dob ||
        favColour != other.favColour ||
        favAnimal != other.favAnimal;
  }

  Child copyWith({
    int? childId,
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

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'name': name,
      'gender': gender,
      'dob': dob.toIso8601String().split('T').first,
      'favColour': favColour,
      'favAnimal': favAnimal,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String,
      dob: DateTime.parse(json['dob'] as String),
      favColour: json['favColour'] as int,
      favAnimal: json['favAnimal'] as int,
    );
  }
}

class ChildState {
  final List<Child> children;
  final Child? selectedChild;
  final bool isFetching;

  ChildState(
      {required this.children, this.selectedChild, required this.isFetching});

  ChildState copyWith(
      {List<Child>? children,
      bool? resetSelectedChild,
      Child? selectedChild,
      bool? isFetching}) {
    return ChildState(
        children: children ?? this.children,
        selectedChild: resetSelectedChild == true
            ? null
            : selectedChild ?? this.selectedChild,
        isFetching: isFetching ?? this.isFetching);
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

  ChildCreate trimmed() {
    return ChildCreate(
        parentId: parentId,
        name: name.trim(),
        gender: gender,
        dob: dob,
        favColour: favColour,
        favAnimal: favAnimal);
  }

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
