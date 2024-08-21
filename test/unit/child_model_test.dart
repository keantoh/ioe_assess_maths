import 'package:math_assessment/src/models/child.dart';
import 'package:test/test.dart';

void main() {
  group('Child Class', () {
    test('hasChanges returns true if any field is different', () {
      final child1 = Child(
        childId: 1,
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final child2 = child1.copyWith(name: 'Bob');

      expect(child1.hasChanges(child2), isTrue);
    });

    test('hasChanges returns false if all fields are identical', () {
      final child1 = Child(
        childId: 1,
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final child2 = child1.copyWith();

      expect(child1.hasChanges(child2), isFalse);
    });

    test('copyWith creates a copy with specified values', () {
      final child1 = Child(
        childId: 1,
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final child2 = child1.copyWith(name: 'Bob');

      expect(child2.name, equals('Bob'));
      expect(child2.childId, equals(child1.childId));
    });

    test('toJson and fromJson work correctly', () {
      final child = Child(
        childId: 1,
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final json = child.toJson();
      expect(json, {
        'childId': 1,
        'name': 'Alice',
        'gender': 'female',
        'dob': '2010-05-20',
        'favColour': 1,
        'favAnimal': 1,
      });

      final fromJsonChild = Child.fromJson(json);
      expect(fromJsonChild.name, equals('Alice'));
      expect(fromJsonChild.dob, equals(DateTime(2010, 5, 20)));
    });
  });

  group('ChildState Class', () {
    test('copyWith retains old values if not provided', () {
      final initialState = ChildState(
        children: [],
        isFetching: false,
      );

      final newState = initialState.copyWith(isFetching: true);

      expect(newState.isFetching, isTrue);
      expect(newState.children, equals(initialState.children));
    });

    test('copyWith can reset selectedChild', () {
      final child = Child(
        childId: 1,
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final initialState = ChildState(
        children: [child],
        selectedChild: child,
        isFetching: false,
      );

      final newState = initialState.copyWith(resetSelectedChild: true);

      expect(newState.selectedChild, isNull);
    });
  });

  group('ChildCreate Class', () {
    test('toJson works correctly', () {
      final childCreate = ChildCreate(
        parentId: 'parent123',
        name: 'Alice',
        gender: 'female',
        dob: DateTime(2010, 5, 20),
        favColour: 1,
        favAnimal: 1,
      );

      final json = childCreate.toJson();
      expect(json, {
        'parentId': 'parent123',
        'name': 'Alice',
        'gender': 'female',
        'dob': '2010-05-20',
        'favColour': 1,
        'favAnimal': 1,
      });
    });
  });
}
