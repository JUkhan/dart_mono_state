import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mono_state/mono_state.dart';
import 'package:todos/states/counter.dart';

void main() {
  Get.put(MonoState([CounterState()]));
  runApp(GetMaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MonoState store = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mono State'),
      ),
      body: Center(
        child: CounterWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.dispatch(Action(type: 'asyncInc'));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final MonoState store = Get.find();
    final counter = useStream<CounterModel?>(
        useMemoized(() => store.select('counter')),
        initialData: CounterModel.init());
    return Container(
      child: counter.data?.isLoading ?? false
          ? CircularProgressIndicator()
          : Text(
              counter.data?.count.toString() ?? '',
              style: Theme.of(context).textTheme.headline1,
            ),
    );
  }
}
