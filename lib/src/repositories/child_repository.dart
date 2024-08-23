import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/services/child_service.dart';

class ChildRepository {
  final ChildService _childService;
  final List<Child> _children = [];

  ChildRepository(this._childService);

  List<Child> get children => List.unmodifiable(_children);

  Future<Map<String, dynamic>> getAllChildren(String userId) async {
    final result = await _childService.fetchChildrenService(userId);
    if (result['status'] == 200) {
      final List<dynamic> responseBody = result['response'];
      final fetchedChildren =
          responseBody.map((json) => Child.fromJson(json)).toList();
      _children.clear();
      _children.addAll(fetchedChildren);
    }
    return result;
  }

  Future<Map<String, dynamic>> addChild(ChildCreate child) async {
    final result = await _childService.addChildService(child);
    if (result['status'] == 201) {
      final newChild = Child.fromJson(result['response']);
      _children.add(newChild);
    }
    return result;
  }

  Future<Map<String, dynamic>> updateChild(Child updatedChild) async {
    final result = await _childService.updateChildService(updatedChild);
    if (result['status'] == 200) {
      final index = _children
          .indexWhere((child) => child.childId == updatedChild.childId);
      if (index != -1) {
        _children[index] = updatedChild;
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> removeChild(int id) async {
    final result = await _childService.deleteChildService(id);
    if (result['status'] == 200) {
      _children.removeWhere((child) => child.childId == id);
    }
    return result;
  }

  void clearAll() {
    _children.clear();
  }
}

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final childService = ref.watch(childServiceProvider);
  return ChildRepository(childService);
});
