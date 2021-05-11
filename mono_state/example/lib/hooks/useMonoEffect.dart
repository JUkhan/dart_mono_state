import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

typedef EffectCallback = Stream<Action> Function(
    Actions action$, MonoState mono);
useMonoEffect<S>(EffectCallback stream$) {
  final MonoState mono = useMono();

  useEffect(() {
    final sub = stream$(mono.action$, mono).listen((action) {
      mono.dispatch(action);
    });
    return () {
      sub.cancel();
    };
  }, [mono]);
}
