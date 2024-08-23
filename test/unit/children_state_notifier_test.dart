import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockChildRepository extends Mock implements ChildRepository {}

void main() {
  late MockChildRepository mockChildRepository;
  late ProviderContainer container;

  setUp(() {
    mockChildRepository = MockChildRepository();
    container = ProviderContainer(overrides: [
      childRepositoryProvider.overrideWithValue(mockChildRepository),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('ChildrenStateNotifier', () {
    test('fetchChildren sets isFetching to true and updates state on success',
        () async {
      const userId = 'test_user_id';
      final children = [
        Child(
          childId: 1,
          name: 'Child1',
          gender: 'Male',
          dob: DateTime(2010, 1, 1),
          favColour: 1,
          favAnimal: 1,
        ),
        Child(
          childId: 2,
          name: 'Child2',
          gender: 'Female',
          dob: DateTime(2012, 2, 2),
          favColour: 2,
          favAnimal: 2,
        ),
      ];

      when(() => mockChildRepository.getAllChildren(userId))
          .thenAnswer((_) async => {'status': 200});
      when(() => mockChildRepository.children).thenReturn(children);

      final notifier = container.read(childrenStateProvider.notifier);

      await notifier.fetchChildren(userId);

      expect(container.read(childrenStateProvider).children, equals(children));
      expect(container.read(childrenStateProvider).isFetching, false);
    });

    test('fetchChildren sets isFetching to false on failure', () async {
      const userId = 'test_user_id';

      when(() => mockChildRepository.getAllChildren(userId))
          .thenAnswer((_) async => {'status': 500});

      final notifier = container.read(childrenStateProvider.notifier);

      await notifier.fetchChildren(userId);

      expect(container.read(childrenStateProvider).children, []);
      expect(container.read(childrenStateProvider).isFetching, false);
    });

    test('addChild updates state on successful addition', () async {
      final newChild = ChildCreate(
        parentId: 'parent_id',
        name: 'New Child',
        gender: 'Other',
        dob: DateTime(2015, 5, 5),
        favColour: 3,
        favAnimal: 3,
      );
      final newChildEntity = Child(
        childId: 3,
        name: 'New Child',
        gender: 'Other',
        dob: DateTime(2015, 5, 5),
        favColour: 3,
        favAnimal: 3,
      );

      when(() => mockChildRepository.addChild(newChild))
          .thenAnswer((_) async => {'status': 201});
      when(() => mockChildRepository.children).thenReturn(
          [...container.read(childrenStateProvider).children, newChildEntity]);

      final notifier = container.read(childrenStateProvider.notifier);

      await notifier.addChild(newChild);

      expect(container.read(childrenStateProvider).children,
          contains(newChildEntity));
    });

    test('updateChild updates state on successful update', () async {
      final updatedChild = Child(
        childId: 1,
        name: 'Updated Child',
        gender: 'Male',
        dob: DateTime(2010, 1, 1),
        favColour: 1,
        favAnimal: 1,
      );

      when(() => mockChildRepository.updateChild(updatedChild))
          .thenAnswer((_) async => {'status': 200});
      when(() => mockChildRepository.children).thenReturn([updatedChild]);

      final notifier = container.read(childrenStateProvider.notifier);

      await notifier.updateChild(updatedChild);

      expect(container.read(childrenStateProvider).selectedChild,
          equals(updatedChild));
    });

    test('removeChild updates state on successful removal', () async {
      const childIdToRemove = 1;

      when(() => mockChildRepository.removeChild(childIdToRemove))
          .thenAnswer((_) async => {'status': 200});
      when(() => mockChildRepository.children).thenReturn([]);

      final notifier = container.read(childrenStateProvider.notifier);

      await notifier.removeChild(childIdToRemove);

      expect(container.read(childrenStateProvider).children, isEmpty);
      expect(container.read(childrenStateProvider).selectedChild, isNull);
    });

    test('clearChildren clears all children', () async {
      final child1 = Child(
        childId: 1,
        name: 'Child1',
        gender: 'Male',
        dob: DateTime(2010, 1, 1),
        favColour: 1,
        favAnimal: 1,
      );
      final child2 = Child(
        childId: 2,
        name: 'Child2',
        gender: 'Female',
        dob: DateTime(2012, 2, 2),
        favColour: 2,
        favAnimal: 2,
      );

      container.read(childrenStateProvider.notifier).state = ChildState(
        children: [child1, child2],
        selectedChild: null,
        isFetching: false,
      );

      when(() => mockChildRepository.children).thenReturn([]);

      final notifier = container.read(childrenStateProvider.notifier);

      notifier.clearChildren();

      expect(container.read(childrenStateProvider).children, isEmpty);
      expect(container.read(childrenStateProvider).selectedChild, isNull);
    });

    test('selectChild sets the selected child', () async {
      final child1 = Child(
        childId: 1,
        name: 'Child1',
        gender: 'Male',
        dob: DateTime(2010, 1, 1),
        favColour: 1,
        favAnimal: 1,
      );
      final child2 = Child(
        childId: 2,
        name: 'Child2',
        gender: 'Female',
        dob: DateTime(2012, 2, 2),
        favColour: 2,
        favAnimal: 2,
      );

      final notifier = container.read(childrenStateProvider.notifier);
      notifier.state = notifier.state.copyWith(children: [child1, child2]);

      notifier.selectChild(2);

      expect(
          container.read(childrenStateProvider).selectedChild, equals(child2));
    });
  });
}
