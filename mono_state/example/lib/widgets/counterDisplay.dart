import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/useSelector.dart';
import '../states/counter.dart';

class CounterDisplay extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useSelector<CounterState, CounterModel?>();

    if (counter.value == null)
      return Text(
        'State Unregistered',
        style: Theme.of(context).textTheme.headline4,
      );
    return Container(
        height: 50,
        child: counter.value!.isLoading
            ? CircularProgressIndicator()
            : Text(
                '${counter.value!.count}',
                style: Theme.of(context).textTheme.headline4,
              ));
  }
}
