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
  CounterState() : super(CounterModel.init());

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
        state = store.getState<CounterState>();
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
    var mono = MonoState(null);

    setUp(() {
      mono = MonoState([CounterState()]);
    });
    tearDown(() {
      mono.dispose();
    });
    ajwahTest<CounterModel>(
      'CounterState initialize',
      build: () => mono.select<CounterState, CounterModel>(),
      expect: [isA<CounterModel>()],
      verify: (models) {
        expect(models[0].count, 0);
        expect(models[0].isLoading, false);
      },
    );
    ajwahTest<CounterModel>(
      'CounterState increment',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.dispatch(Action(type: 'inc'));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0].count, 1);
        expect(models[0].isLoading, false);
      },
    );

    ajwahTest<CounterModel>(
      'CounterState decrement',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.dispatch(Action(type: 'dec'));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0].count, -1);
        expect(models[0].isLoading, false);
      },
    );
    ajwahTest<CounterModel>(
      'CounterState asyncInc',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.dispatch(Action(type: 'asyncInc'));
      },
      expect: [isA<CounterModel>(), isA<CounterModel>()],
      skip: 1,
      wait: const Duration(milliseconds: 10),
      verify: (models) {
        expect(models[0].isLoading, true);
        expect(models[1].isLoading, false);
        expect(models[1].count, 1);
      },
    );
    ajwahTest<CounterModel>(
      'importState',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.importState<CounterState>(CounterModel(101, false));
      },
      expect: [isA<CounterModel>()],
      skip: 1,
      verify: (models) {
        expect(models[0].count, 101);
        expect(models[0].isLoading, false);
      },
    );
    ajwahTest<CounterModel>(
      'unregister state',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.unregisterState<CounterState>();
      },
      expect: [],
      skip: 1,
    );

    ajwahTest<Action>(
      'action handler whereType',
      build: () => mono.action$.whereType('mono'),
      act: () {
        mono.dispatch(Action(type: 'mono'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'mono');
      },
    );

    ajwahTest<Action>(
      'action handler whereTypes',
      build: () => mono.action$.whereTypes(['monoX', 'mono']),
      act: () {
        mono.dispatch(Action(type: 'mono'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'mono');
      },
    );
    ajwahTest<Action>(
      'action handler where',
      build: () => mono.action$.where((action) => action.type == 'mono'),
      act: () {
        mono.dispatch(Action(type: 'mono'));
      },
      expect: [isA<Action>()],
      verify: (models) {
        expect(models[0].type, 'mono');
      },
    );

    ajwahTest<CounterModel>(
      'dispose',
      build: () => mono.select<CounterState, CounterModel>(),
      act: () {
        mono.dispose();
        mono.dispatch(Action(type: 'inc'));
      },
      expect: [isA<CounterModel>()],
      verify: (models) {
        expect(models.length, 1);
        expect(models[0].count, 0);
        expect(models[0].isLoading, false);
      },
    );
  });
}

```
