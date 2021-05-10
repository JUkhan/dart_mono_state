import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

ValueNotifier<S> useSelector<S>(String stateName) {
  final MonoState mono = useMono();
  final state = useState<S>(mono.getState(stateName));
  useEffect(() {
    final sub = mono.select<S>(stateName).listen((res) {
      state.value = res;
    });
    return () {
      sub.cancel();
    };
  }, [stateName, mono]);
  return state;
}
