import 'package:mono_state/mono_state.dart';
import 'package:uuid/uuid.dart';

import '../api/todoApi.dart';

var _uuid = Uuid();

class Todo {
  Todo({
    required this.description,
    this.completed = false,
    String? id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String description;
  final bool completed;

  Todo copyWith({
    String? id,
    String? description,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

class TodoState extends StateBase<List<Todo>> {
  TodoState() : super([]);

  @override
  void mapActionToState(
      List<Todo> state, Action action, emit, MonoState store) {
    if (action is AddTodoAction) {
      addTodo(Todo(description: action.description))
          .listen((todo) => emit([...state, todo]));
    } else if (action is UpdateTodoAction) {
      updateTodo(action.todo).listen(
          (todo) => emit([
                for (var item in state)
                  if (item.id == todo.id) todo else item,
              ]), onError: (error) {
        store.dispatch(TodoErrorAction(error));
      });
    } else if (action is RemoveTodoAction) {
      removeTodo(action.todo).listen(
          (todo) => emit(state.where((item) => item.id != todo.id).toList()));
    } else if (action is RegisterStateAction && action.type == 'TodoState') {
      getTodos().listen((todos) {
        emit(todos);
      });
    }
  }
}

class AddTodoAction extends Action {
  final String description;
  AddTodoAction(this.description);
}

class UpdateTodoAction extends Action {
  final Todo todo;
  UpdateTodoAction(this.todo);
}

class RemoveTodoAction extends Action {
  final Todo todo;
  RemoveTodoAction(this.todo);
}

class TodoErrorAction extends Action {
  final dynamic error;
  TodoErrorAction(this.error);
}

class SearchTodoAction extends Action {
  final String searchText;
  SearchTodoAction(this.searchText);
}

class SearchInputAction extends Action {
  final String searchText;
  SearchInputAction(this.searchText);
}
