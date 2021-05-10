import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mono_state/mono_state.dart';
import 'package:todos/hooks/useDispatch.dart';
import 'package:todos/hooks/useSelector.dart';
import 'package:todos/states/counter.dart';

void main() {
  Get.put(MonoState([CounterState()]));
  runApp(GetMaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mono State'),
      ),
      body: Center(
        child: CounterDisplay(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              dispatch(Action(type: 'inc'));
            },
            child: const Text('Inc'),
          ),
          RaisedButton(
            onPressed: () {
              dispatch(Action(type: 'dec'));
            },
            child: const Text('Dec'),
          ),
          RaisedButton(
            onPressed: () {
              dispatch(Action(type: 'asyncInc'));
            },
            child: const Text('Async Inc'),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CounterDisplay extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useSelector<CounterModel>('counter');

    return Container(
        child: counter.value.isLoading
            ? CircularProgressIndicator()
            : Text(
                counter.value.count.toString(),
                style: Theme.of(context).textTheme.headline3,
              ));
  }
}
