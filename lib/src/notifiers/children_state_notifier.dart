import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/child_api.dart';
import 'package:math_assessment/src/data/models/child_models.dart';

class ChildrenStateNotifier extends StateNotifier<List<Child>?> {
  ChildrenStateNotifier() : super(null);

  void setChildren(List<Child> children) {
    state = children;
  }

  void addChild(Child child) {
    if (state != null) {
      state = [...state!, child];
    } else {
      state = [child];
    }
  }

  void removeChild(String id) {
    if (state != null) {
      state = state!.where((child) => child.childId != id).toList();
    }
  }

  void updateChild(Child updatedChild) {
    if (state != null) {
      state = state!.map((child) {
        return child.childId == updatedChild.childId ? updatedChild : child;
      }).toList();
    }
  }

  void clearChildren() {
    state = null;
  }

  void fetchChildren(userId) async {
    if (userId != null) {
      final children = await getChildren(userId);
      setChildren(children);
    }
  }
}

final childrenStateProvider =
    StateNotifierProvider<ChildrenStateNotifier, List<Child>?>(
        (ref) => ChildrenStateNotifier());
