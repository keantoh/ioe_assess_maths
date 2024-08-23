import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';

class ChildrenStateNotifier extends StateNotifier<ChildState> {
  final ChildRepository _childRepository;
  final Ref ref;
  int? _responseCode;

  ChildrenStateNotifier(this._childRepository, this.ref, userId)
      : super(
            ChildState(children: [], selectedChild: null, isFetching: false)) {
    fetchChildren(userId);
  }

  int? get responseCode => _responseCode;

  Future<void> fetchChildren(userId) async {
    if (userId != null) {
      state = state.copyWith(isFetching: true);
      final result = await _childRepository.getAllChildren(userId);
      final responseCode = result['status'];

      if (responseCode == 200) {
        state = state.copyWith(
            children: _childRepository.children, isFetching: false);
      } else {
        state = state.copyWith(isFetching: false);
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
    state = ChildState(
        children: _childRepository.children,
        selectedChild: null,
        isFetching: false);
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
  final userId = ref.watch(userStateProvider)?.userId;
  return ChildrenStateNotifier(childRepository, ref, userId);
});

final childrenResponseCodeProvider = StateProvider<int?>(
    (ref) => ref.watch(childrenStateProvider.notifier).responseCode);
