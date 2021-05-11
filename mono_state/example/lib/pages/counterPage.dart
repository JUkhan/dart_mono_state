import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

import '../hooks/useMonoEffect.dart';
import '../hooks/useDispatch.dart';
import '../hooks/useMono.dart';
import '../states/counter.dart';
import '../widgets/counterDisplay.dart';
import './nav.dart';

class CounterPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useMonoEffect((action$, _) => action$
        .isA<AsyncIncrement>()
        .delay(const Duration(seconds: 1))
        .mapTo(Increment()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
        actions: nav(),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          counterActions(),
          CounterDisplay(),
          stateRegisterUnregister(),
        ],
      )),
    );
  }

  Row stateRegisterUnregister() {
    final mono = useMono();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            mono.registerState(CounterState());
          },
          child: const Text('Register State'),
        ),
        ElevatedButton(
          onPressed: () {
            mono.unregisterState<CounterState>();
          },
          child: const Text('Unregister State'),
        ),
      ],
    );
  }

  Row counterActions() {
    final dispatch = useDispatch();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            dispatch(Increment());
          },
          child: const Text('Inc'),
        ),
        ElevatedButton(
          onPressed: () {
            dispatch(Decrement());
          },
          child: const Text('Dec'),
        ),
        ElevatedButton(
          onPressed: () {
            dispatch(AsyncIncrement());
          },
          child: const Text('Async Inc'),
        ),
      ],
    );
  }
}
