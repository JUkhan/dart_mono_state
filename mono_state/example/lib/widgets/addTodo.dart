import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos/hooks/useMonoEffect.dart';
import '../states/todo.dart';
import '../hooks/useDispatch.dart';

class AddTodo extends HookWidget {
  const AddTodo();

  @override
  Widget build(BuildContext context) {
    final newTodoController = useTextEditingController();
    final dispatch = useDispatch();
    final isSearchEnable = useState(false);

    useMonoEffect(
      (action$, _) => action$
          .isA<SearchInputAction>()
          .debounceTime(const Duration(milliseconds: 320))
          .map((action) => SearchTodoAction(action.searchText)),
    );

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              onChanged: (txt) {
                if (isSearchEnable.value) dispatch(SearchInputAction(txt));
              },
              autofocus: true,
              controller: newTodoController,
              decoration: InputDecoration(
                labelText: isSearchEnable.value
                    ? 'Search Todo'
                    : 'What needs to be done?',
              ),
              onSubmitted: (value) {
                if (!isSearchEnable.value) {
                  dispatch(AddTodoAction(value));
                  newTodoController.clear();
                }
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              isSearchEnable.value = !isSearchEnable.value;
            },
            child: const Icon(Icons.search),
            mini: true,
          ),
        ],
      ),
    );
  }
}
