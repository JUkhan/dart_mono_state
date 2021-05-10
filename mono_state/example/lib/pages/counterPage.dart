import 'package:flutter/material.dart' hide Action;
import 'package:mono_state/mono_state.dart';

import '../hooks/useDispatch.dart';
import '../hooks/useMono.dart';
import '../states/counter.dart';
import '../widgets/counterDisplay.dart';
import './nav.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
        actions: nav(),
      ),

      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          counterActions(dispatch),
          CounterDisplay(),
          stateRegisterUnregister(),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
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
            mono.unregisterState('counter');
          },
          child: const Text('Unregister State'),
        ),
      ],
    );
  }

  Row counterActions(void Function(Action) dispatch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            dispatch(Action(type: 'inc'));
          },
          child: const Text('Inc'),
        ),
        ElevatedButton(
          onPressed: () {
            dispatch(Action(type: 'dec'));
          },
          child: const Text('Dec'),
        ),
        ElevatedButton(
          onPressed: () {
            dispatch(Action(type: 'asyncInc'));
          },
          child: const Text('Async Inc'),
        ),
      ],
    );
  }
}
