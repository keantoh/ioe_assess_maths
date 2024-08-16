import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/child.dart';

class ChildRepository {
  final List<Child> _children = [];

  List<Child> getAllChildren() {
    return List.from(_children);
  }

  void addChild(Child child) {
    _children.add(child);
  }

  void removeChild(int id) {
    _children.removeWhere((child) => child.childId == id);
  }

  void updateChild(Child updatedChild) {
    final index =
        _children.indexWhere((child) => child.childId == updatedChild.childId);
    if (index != -1) {
      _children[index] = updatedChild;
    }
  }

  void clearAll() {
    _children.clear();
  }
}

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepository();
});
