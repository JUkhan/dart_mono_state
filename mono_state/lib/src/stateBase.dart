import 'action.dart';
import 'monoState.dart';

typedef EmitCallback<S> = void Function(S state);

///Every state class must derived from `StateBase<T>` class. And it is mandatory to pass the
///state `name` and `initialState`.
///
/// **Example:**
///```dart
///class CounterModel {
///  int count;
///  bool isLoading;
///
///  CounterModel({this.count, this.isLoading});
///
///  copyWith({int count, bool isLoading}) {
///    return CounterModel(
///        count: count ?? this.count, isLoading: isLoading ?? this.isLoading);
///  }
///
///  CounterModel.init() : this(count: 10, isLoading: false);
///}
///
///class CounterState extends StateBase<CounterModel> {
///  CounterState() : super(name: 'counter', initialState: CounterModel.init());
///
///  Stream<CounterModel> mapActionToState(
///      CounterModel state, Action action, Store store) async* {
///    switch (action.type) {
///      case ActionTypes.Inc:
///        state.count++;
///        yield state.copyWith(isLoading: false);
///        break;
///      case ActionTypes.Dec:
///        state.count--;
///        yield state.copyWith(isLoading: false);
///        break;
///      case ActionTypes.AsyncInc:
///        yield state.copyWith(isLoading: true);
///        yield await getCount(state.count);
///        break;
///      default:
///        yield getState(store);
///    }
///  }
///
///  Future<CounterModel> getCount(int count) {
///    return Future.delayed(Duration(milliseconds: 500),
///        () => CounterModel(count: count + 1, isLoading: false));
///  }
///}
///
///```
abstract class StateBase<S> {
  final String stateName;
  final S initialState;

  StateBase({required this.stateName, required this.initialState});

  ///This function should be invoked whenever action dispatchd to the store.
  ///
  ///**Example**
  ///```dart
  ///   Stream<CounterModel> mapActionToState(
  ///     CounterModel state, Action action, Store store) async* {
  ///     switch (action.type) {
  ///       case ActionTypes.Inc:
  ///         yield increment(state, action);
  ///         break;
  ///       default: yield getState(store);
  ///     }
  ///   }
  /// ```
  void mapActionToState(
      S state, Action action, EmitCallback<S> emit, MonoState store);
}
