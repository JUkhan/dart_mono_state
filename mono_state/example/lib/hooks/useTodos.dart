import 'package:rxdart/rxdart.dart';
import 'package:todos/hooks/useActionHandler.dart';
import 'package:todos/states/searchCategory.dart';
import 'package:todos/states/todo.dart';

List<Todo> useTodos() {
  final response = useActionHandler<List<Todo>>((action$, mono) {
    return Rx.combineLatest3<List<Todo>, SearchCategory, String, List<Todo>>(
        mono.select<TodoState, List<Todo>>(),
        mono.select<SearchCategoryState, SearchCategory>(),
        action$
            .isA<SearchTodoAction>()
            .map<String>((action) => action.searchText)
            .startWith(''), (todos, category, searchText) {
      if (searchText.isNotEmpty)
        todos = todos
            .where((todo) => todo.description
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      switch (category) {
        case SearchCategory.Active:
          return todos.where((todo) => !todo.completed).toList();
        case SearchCategory.Completed:
          return todos.where((todo) => todo.completed).toList();
        default:
          return todos;
      }
    });
  });

  return response.value.data ?? [];
}
