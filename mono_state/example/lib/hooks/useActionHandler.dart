/*import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

typedef ActionHandllerCallback<S> = Stream<S> Function(
    Actions action$, MonoState mono);

abstract class ActionHandlerResponse {}

class ActionHandlerErrorResponse extends ActionHandlerResponse {
  final dynamic error;
  ActionHandlerErrorResponse(this.error);
}

class ActionHandlerLoadingResponse extends ActionHandlerResponse {}

class ActionHandlerDataResponse<S> extends ActionHandlerResponse {
  final S data;
  ActionHandlerDataResponse(this.data);
}

ValueNotifier<ActionHandlerResponse> useActionHandler<S>(
    ActionHandllerCallback<S> stream$) {
  final MonoState mono = useMono();
  final state = useState<ActionHandlerResponse>(ActionHandlerLoadingResponse());
  useEffect(() {
    final sub = stream$(mono.action$, mono).listen((res) {
      state.value = new ActionHandlerDataResponse<S>(res);
    }, onError: ((err) {
      state.value = new ActionHandlerErrorResponse(err);
    }));
    return () {
      sub.cancel();
    };
  }, [mono]);

  return state;
}*/
import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mono_state/mono_state.dart';
import './useMono.dart';

typedef EffectCallback<S> = Stream<S> Function(
    Actions action$, MonoState store);

class ActionHandlerResponse<S> {
  final bool loading;
  final dynamic? error;
  final S? data;
  ActionHandlerResponse(this.loading, this.error, this.data);
}

ValueNotifier<ActionHandlerResponse<S>> useActionHandler<S>(
    EffectCallback<S> stream$) {
  final MonoState mono = useMono();
  final state = useState<ActionHandlerResponse<S>>(
      new ActionHandlerResponse(true, null, null));
  useEffect(() {
    final sub = stream$(mono.action$, mono).listen((res) {
      state.value = new ActionHandlerResponse<S>(false, null, res);
    }, onError: ((err) {
      state.value = new ActionHandlerResponse<S>(false, err, state.value.data);
    }));
    return () {
      sub.cancel();
    };
  }, [mono]);

  return state;
}
