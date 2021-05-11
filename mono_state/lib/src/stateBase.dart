import 'action.dart';
import 'monoState.dart';

typedef EmitCallback<S> = void Function(S state);

abstract class StateBase<S> {
  final S initialState;

  StateBase(this.initialState);

  void mapActionToState(
      S state, Action action, EmitCallback<S> emit, MonoState mono);
}
