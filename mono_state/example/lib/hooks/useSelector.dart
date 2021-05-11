import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

ValueNotifier<Model> useSelector<State, Model>() {
  final MonoState mono = useMono();
  final state = useState<Model>(mono.getState<State>());
  useEffect(() {
    final sub = mono.select<State, Model>().listen((res) {
      state.value = res;
    });
    return () {
      sub.cancel();
    };
  }, [State, mono]);
  return state;
}
