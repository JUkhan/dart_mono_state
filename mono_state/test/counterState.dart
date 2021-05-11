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
      CounterModel state, Action action, emit, MonoState store) async {
    switch (action.type) {
      case 'inc':
        emit(state.copyWith(count: state.count + 1, isLoading: false));
        break;
      case 'dec':
        emit(state.copyWith(count: state.count - 1, isLoading: false));

        break;
      case 'asyncInc':
        emit(state.copyWith(isLoading: true));
        await Future.delayed(const Duration(milliseconds: 10));
        state = store.getState<CounterState>();
        emit(state.copyWith(count: state.count + 1, isLoading: false));

        break;
      default:
    }
  }
}
