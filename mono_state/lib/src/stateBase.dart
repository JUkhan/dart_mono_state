import 'action.dart';
import 'monoState.dart';

typedef EmitCallback<S> = void Function(S state);

abstract class StateBase<S> {
  final String stateName;
  final S initialState;

  StateBase({required this.stateName, required this.initialState});

  void mapActionToState(
      S state, Action action, EmitCallback<S> emit, MonoState store);
}
