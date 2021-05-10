import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'action.dart';
import 'actions.dart';
import 'stateBase.dart';

class MonoState {
  BehaviorSubject<Action>? __dispatcher;
  BehaviorSubject<Map<String, dynamic>>? __store;
  Map<String, StreamSubscription<Action>>? __subscriptions;
  Actions? _actions;
  MonoState(List<StateBase>? reducers) {
    var dispatcher = BehaviorSubject<Action>.seeded(Action(type: '@@INIT'));
    __dispatcher = dispatcher;
    __store = BehaviorSubject<Map<String, dynamic>>.seeded({});
    _actions = Actions(dispatcher);
    __subscriptions = <String, StreamSubscription<Action>>{};
    reducers?.forEach((reducer) {
      registerState(reducer);
    });
  }
  BehaviorSubject<Action> get _dispatcher =>
      __dispatcher ?? BehaviorSubject<Action>.seeded(Action(type: '@@INIT'));

  BehaviorSubject<Map<String, dynamic>> get _store =>
      __store ?? BehaviorSubject<Map<String, dynamic>>.seeded({});

  Map<String, StreamSubscription<Action>> get _subscriptions =>
      __subscriptions ?? <String, StreamSubscription<Action>>{};

  Stream<Map<String, dynamic>> get store$ => _store.asBroadcastStream();
  Stream<Action> get dispatcher$ => _dispatcher.asBroadcastStream();
  Actions get action$ => _actions ?? Actions(_dispatcher);

  void registerState(StateBase reducer) {
    if (_store.value.containsKey(reducer.stateName)) {
      return;
    }
    final ns = _newState();
    ns[reducer.stateName] = reducer.initialState;
    _store.add(ns);
    dispatch(Action(type: 'registerState(${reducer.stateName})'));
    void emitState(dynamic state) {
      if (_store.value[reducer.stateName] != state) {
        final ns = _newState();
        ns[reducer.stateName] = state;
        _store.add(ns);
      }
    }

    _subscriptions[reducer.stateName] = _dispatcher.listen((action) {
      reducer.mapActionToState(
          _store.value[reducer.stateName], action, emitState, this);
    });
  }

  Stream<T> select<T>(String stateName) {
    return _store.map<T>((dic) => dic[stateName]).distinct();
  }

  S getState<S>(String stateName) {
    return _store.value[stateName];
  }

  void dispatch(Action action) {
    _dispatcher.add(action);
  }

  void unregisterState(String stateName) {
    if (_subscriptions.containsKey(stateName)) {
      _subscriptions[stateName]?.cancel();
      _subscriptions.remove(stateName);
      final newState = _newState();
      newState.remove(stateName);
      _store.add(newState);
      dispatch(Action(type: 'unregisterState($stateName)'));
    }
  }

  void importState(String stateName, dynamic state) {
    if (_store.value.containsKey(stateName)) {
      final newState = _newState();
      newState[stateName] = state;
      _store.add(newState);
      dispatch(Action(type: '@importState'));
    }
  }

  Map<String, dynamic> _newState() {
    final map = <String, dynamic>{};
    final oldMap = _store.value;
    for (var key in oldMap.keys) {
      map[key] = oldMap[key];
    }
    return map;
  }

  ///It's a clean up function.
  void dispose() {
    _subscriptions.forEach((key, value) {
      value.cancel();
    });
    _subscriptions.clear();
  }
}
