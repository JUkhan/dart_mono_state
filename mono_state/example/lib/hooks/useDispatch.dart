import 'package:mono_state/mono_state.dart';

import './useMono.dart';

void Function(Action) useDispatch() {
  final MonoState mono = useMono();
  return mono.dispatch;
}
