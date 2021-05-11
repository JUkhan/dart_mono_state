import 'package:mono_state/mono_state.dart';

class CounterModel {
  final int count;
  final bool isLoading;

  CounterModel(this.count, this.isLoading);

  factory CounterModel.init() => CounterModel(0, false);

  CounterModel copyWith({int? count, bool isLoading = false}) =>
      CounterModel(count ?? this.count, isLoading);

  @override
  String toString() {
    return 'count: $count, loading: $isLoading';
  }
}

class CounterState extends StateBase<CounterModel> {
  CounterState() : super(CounterModel.init());

  @override
  void mapActionToState(
      CounterModel state, Action action, emit, MonoState mono) async {
    if (action is Increment) {
      emit(state.copyWith(count: state.count + 1, isLoading: false));
    } else if (action is Decrement) {
      emit(state.copyWith(count: state.count - 1, isLoading: false));
    } else if (action is AsyncIncrement) {
      emit(state.copyWith(isLoading: true));
    }
  }
}

class Increment extends Action {}

class Decrement extends Action {}

class AsyncIncrement extends Action {}
