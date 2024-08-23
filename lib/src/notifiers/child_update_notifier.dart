import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';

class ChildUpdateNotifier extends StateNotifier<Child> {
  ChildUpdateNotifier(super.state);

  void updateName(String name) {
    state = Child(
        childId: state.childId,
        name: name,
        gender: state.gender,
        dob: state.dob,
        favAnimal: state.favAnimal,
        favColour: state.favColour);
  }

  void updateGender(String gender) {
    state = Child(
        childId: state.childId,
        name: state.name,
        gender: gender,
        dob: state.dob,
        favAnimal: state.favAnimal,
        favColour: state.favColour);
  }

  void updateDob(DateTime dob) {
    state = Child(
        childId: state.childId,
        name: state.name,
        gender: state.gender,
        dob: dob,
        favAnimal: state.favAnimal,
        favColour: state.favColour);
  }

  void updateFavAnimal(int favAnimal) {
    state = Child(
        childId: state.childId,
        name: state.name,
        gender: state.gender,
        dob: state.dob,
        favAnimal: favAnimal,
        favColour: state.favColour);
  }

  void updateFavColour(int favColour) {
    state = Child(
        childId: state.childId,
        name: state.name,
        gender: state.gender,
        dob: state.dob,
        favAnimal: state.favAnimal,
        favColour: favColour);
  }

  bool get hasChanges {
    if (originalDetails == null) {
      return false;
    } else {
      return state.hasChanges(originalDetails!);
    }
  }

  Child? originalDetails;

  void setOriginalDetails(Child details) {
    originalDetails = details;
  }

  void syncWithSelectedChild(Child selectedChild) {
    state = selectedChild;
    setOriginalDetails(selectedChild);
  }
}

final childUpdateProvider = StateNotifierProvider<ChildUpdateNotifier, Child>(
  (ref) {
    final childState = ref.watch(childrenStateProvider).selectedChild;
    final initialDetails = childState != null
        ? Child(
            childId: childState.childId,
            name: childState.name,
            gender: childState.gender,
            dob: childState.dob,
            favAnimal: childState.favAnimal,
            favColour: childState.favColour,
          )
        : Child(
            childId: 0,
            name: '',
            gender: '',
            dob: DateTime.now(),
            favAnimal: 1,
            favColour: 1,
          );
    final notifier = ChildUpdateNotifier(initialDetails);
    notifier.setOriginalDetails(initialDetails);
    return notifier;
  },
);
