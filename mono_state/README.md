State Management Lib - reactive and less boilerplate

## Usage

A simple usage example:

```dart
import 'package:mono_state/mono_state.dart';

class CounterModel {
  final int count;
  final bool isLoading;

  CounterModel(this.count, this.isLoading);

  factory CounterModel.init() => CounterModel(0, false);

  CounterModel copyWith({int? count, bool isLoading = false}) =>
      CounterModel(count ?? this.count, isLoading);

  @override
  String toString() {
    return 'count: $count, loading: $isLoading';
  }
}

class CounterState extends StateBase<CounterModel> {
  CounterState()
      : super(stateName: 'counter', initialState: CounterModel.init());

  @override
  void mapActionToState(
      CounterModel state, Action action, emit, MonoState store) async {
    switch (action.type) {
      case 'inc':
        emit(state.copyWith(count: state.count + 1, isLoading: false));
        break;
      case 'dec':
        emit(state.copyWith(count: state.count - 1, isLoading: false));

        break;
      case 'asyncInc':
        emit(state.copyWith(isLoading: true));
        await Future.delayed(const Duration(milliseconds: 10));
        state = store.getState('counter');
        emit(state.copyWith(count: state.count + 1, isLoading: false));

        break;
      default:
    }
  }
}


```

## Testing

```dart
import 'package:ajwah_bloc_test/ajwah_bloc_test.dart';
import 'package:mono_state/mono_state.dart';
import 'package:test/test.dart';
import 'counterState.dart';

void main() {
  group('mono_state - ', () {
    var awesome = MonoState(null);

    setUp(() {
      awesome = MonoState([CounterState()]);
    });
    tearDown(() {
      awesome.dispose();
    });
    ajwahTest<CounterModel?>(
      'CounterState initialize',
      build: () => awesome.select<CounterModel>('counter'),
      expect: [isA<CounterModel>()],
      verify: (models) {
        expect(models[0]?.count, 0);
        expect(models[0]?.isLoading, false);
      },
    );
    ajwahTest<CounterModel?>(
      'CounterState increment',
      build: () => awesome.select<CounterModel>('counter'),
      act: () {
        awesome.dispatch(Action(type: 'inc'));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0]?.count, 1);
        expect(models[0]?.isLoading, false);
      },
    );

    ajwahTest<CounterModel?>(
      'CounterState decrement',
      build: () => awesome.select<CounterModel>('counter'),
      act: () {
        awesome.dispatch(Action(type: 'dec'));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0]?.count, -1);
        expect(models[0]?.isLoading, false);
      },
    );
    ajwahTest<CounterModel?>(
      'CounterState asyncInc',
      build: () => awesome.select<CounterModel>('counter'),
      act: () {
        awesome.dispatch(Action(type: 'asyncInc'));
      },
      expect: [isA<CounterModel>(), isA<CounterModel>()],
      skip: 1,
      wait: const Duration(milliseconds: 10),
      verify: (models) {
        expect(models[0]?.isLoading, true);
        expect(models[1]?.isLoading, false);
        expect(models[1]?.count, 1);
      },
    );
    ajwahTest<CounterModel?>(
      'importState',
      build: () => awesome.select<CounterModel>('counter'),
      act: () {
        awesome.importState('counter', CounterModel(101, false));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0]?.count, 101);
        expect(models[0]?.isLoading, false);
      },
    );
    ajwahTest<CounterModel?>('unregister state',
        build: () => awesome.select<CounterModel>('counter'),
        act: () {
          awesome.unregisterState('counter');
        },
        expect: [null],
        skip: 1);

    ajwahTest<Action>(
      'action handler whereType',
      build: () => awesome.action$.whereType('awesome'),
      act: () {
        awesome.dispatch(Action(type: 'awesome'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'awesome');
      },
    );

    ajwahTest<Action>(
      'action handler whereTypes',
      build: () => awesome.action$.whereTypes(['awesomeX', 'awesome']),
      act: () {
        awesome.dispatch(Action(type: 'awesome'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'awesome');
      },
    );
    ajwahTest<Action>(
      'action handler where',
      build: () => awesome.action$.where((action) => action.type == 'awesome'),
      act: () {
        awesome.dispatch(Action(type: 'awesome'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'awesome');
      },
    );
    ajwahTest<CounterModel?>(
      'dispose',
      build: () => awesome.select<CounterModel>('counter'),
      act: () {
        awesome.dispose();
        awesome.dispatch(Action(type: 'inc'));
      },
      expect: [isA<CounterModel>()],
      verify: (models) {
        expect(models[0]?.count, 0);
        expect(models[0]?.isLoading, false);
      },
    );
  });
}

```
