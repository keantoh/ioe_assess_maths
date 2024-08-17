import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/child.dart';
import 'package:math_assessment/src/repositories/child_repository.dart';

class ChildrenStateNotifier extends StateNotifier<ChildState> {
  final ChildRepository _childRepository;
  final Ref ref;
  int? _responseCode;

  ChildrenStateNotifier(this._childRepository, this.ref)
      : super(ChildState(children: [], selectedChild: null));

  int? get responseCode => _responseCode;

  void fetchChildren(userId) async {
    if (userId != null) {
      final result = await _childRepository.getAllChildren(userId);
      final responseCode = result['status'];

      if (responseCode == 200) {
        state = state.copyWith(children: _childRepository.children);
      }
    }
  }

  Future<void> addChild(ChildCreate child) async {
    final result = await _childRepository.addChild(child);
    final responseCode = result['status'];

    if (responseCode == 201) {
      state = state.copyWith(children: _childRepository.children);
    }

    ref.read(childrenResponseCodeProvider.notifier).state = responseCode;
  }

  Future<void> updateChild(Child updatedChild) async {
    final result = await _childRepository.updateChild(updatedChild);
    final responseCode = result['status'];

    if (responseCode == 200) {
      state = state.copyWith(
          children: _childRepository.children, selectedChild: updatedChild);
    }
    ref.read(childrenResponseCodeProvider.notifier).state = responseCode;
  }

  Future<void> removeChild(int childId) async {
    final result = await _childRepository.removeChild(childId);
    final responseCode = result['status'];

    if (responseCode == 200) {
      state = state.copyWith(
          children: _childRepository.children, resetSelectedChild: true);
    }
    ref.read(childrenResponseCodeProvider.notifier).state = responseCode;
  }

  void clearChildren() {
    _childRepository.clearAll();
    state =
        ChildState(children: _childRepository.children, selectedChild: null);
  }

  void selectChild(int childId) {
    final index =
        state.children.indexWhere((child) => child.childId == childId);

    state = state.copyWith(selectedChild: state.children[index]);
  }
}

final childrenStateProvider =
    StateNotifierProvider<ChildrenStateNotifier, ChildState>((ref) {
  final childRepository = ref.watch(childRepositoryProvider);
  return ChildrenStateNotifier(childRepository, ref);
});

final childrenResponseCodeProvider = StateProvider<int?>(
    (ref) => ref.watch(childrenStateProvider.notifier).responseCode);
