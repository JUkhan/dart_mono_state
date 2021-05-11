import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'action.dart';
import 'actions.dart';
import 'stateBase.dart';

class MonoState {
  BehaviorSubject<Action>? __dispatcher;
  BehaviorSubject<Map<Type, dynamic>>? __store;
  Map<Type, StreamSubscription<Action>>? __subscriptions;
  Actions? _actions;
  MonoState(List<StateBase>? reducers) {
    var dispatcher = BehaviorSubject<Action>.seeded(Action(type: '@@INIT'));
    __dispatcher = dispatcher;
    __store = BehaviorSubject<Map<Type, dynamic>>.seeded({});
    _actions = Actions(dispatcher);
    __subscriptions = <Type, StreamSubscription<Action>>{};
    reducers?.forEach((reducer) {
      registerState(reducer);
    });
  }
  BehaviorSubject<Action> get _dispatcher =>
      __dispatcher ?? BehaviorSubject<Action>.seeded(Action(type: '@@INIT'));

  BehaviorSubject<Map<Type, dynamic>> get _store =>
      __store ?? BehaviorSubject<Map<Type, dynamic>>.seeded({});

  Map<Type, StreamSubscription<Action>> get _subscriptions =>
      __subscriptions ?? <Type, StreamSubscription<Action>>{};

  Stream<Map<Type, dynamic>> get store$ => _store.asBroadcastStream();
  Stream<Action> get dispatcher$ => _dispatcher.asBroadcastStream();
  Actions get action$ => _actions ?? Actions(_dispatcher);

  void registerState(StateBase reducer) {
    if (_store.value.containsKey(reducer.runtimeType)) {
      return;
    }
    final ns = _newState();

    ns[reducer.runtimeType] = reducer.initialState;
    _store.add(ns);

    void emitState(dynamic state) {
      if (_store.value[reducer.runtimeType] != state) {
        final ns = _newState();
        ns[reducer.runtimeType] = state;
        _store.add(ns);
      }
    }

    _subscriptions[reducer.runtimeType] = _dispatcher.listen((action) {
      reducer.mapActionToState(
          _store.value[reducer.runtimeType], action, emitState, this);
    });

    dispatch(RegisterStateAction('${reducer.runtimeType}'));
  }

  Stream<Model> select<State, Model>() {
    return _store.map<Model>((dic) => dic[State]).distinct();
  }

  dynamic getState<State>() {
    return _store.value[State];
  }

  void dispatch(Action action) {
    _dispatcher.add(action);
  }

  void unregisterState<State>() {
    if (_subscriptions.containsKey(State)) {
      dispatch(UnregisterStateAction('$State'));
      _subscriptions[State]?.cancel();
      _subscriptions.remove(State);
      final newState = _newState();
      newState.remove(State);
      _store.add(newState);
    }
  }

  void importState<State>(dynamic state) {
    if (_store.value.containsKey(State)) {
      final newState = _newState();
      newState[State] = state;
      _store.add(newState);
      dispatch(ImportStateAction('$State'));
    }
  }

  Map<Type, dynamic> _newState() {
    final map = <Type, dynamic>{};
    final oldMap = _store.value;
    for (var key in oldMap.keys) {
      map[key] = oldMap[key];
    }
    return map;
  }

  ///clean up function.
  void dispose() {
    _subscriptions.forEach((key, value) {
      value.cancel();
    });
    _subscriptions.clear();
  }
}
