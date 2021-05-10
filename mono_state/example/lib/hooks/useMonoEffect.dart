import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

typedef EffectCallback = Stream<Action> Function(
    Actions action$, MonoState store);
useMonoEffect<S>(EffectCallback stream$) {
  final MonoState mono = useMono();

  useEffect(() {
    print('----useMonoEffect-----');
    final sub = stream$(mono.action$, mono).listen((action) {
      mono.dispatch(action);
    });
    return () {
      print('-------unsubscribe of mono effect------  ');
      sub.cancel();
    };
  }, [mono]);
}
