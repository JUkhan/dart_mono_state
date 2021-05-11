import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos/hooks/useActionHandler.dart';
import 'package:todos/hooks/useDispatch.dart';
import 'package:todos/hooks/useSelector.dart';
import '../states/searchCategory.dart';
import '../states/todo.dart';

class Toolbar extends HookWidget {
  const Toolbar();

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();

    final sc = useSelector<SearchCategoryState, SearchCategory>().value;

    final activeTodosInfo = useActionHandler<String?>((_, mono) => mono
        .select<TodoState, List<Todo>>()
        .map((todos) => todos.where((todo) => !todo.completed).toList())
        .map((todos) => '${todos.length} items left')).value;

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              activeTodosInfo.data ?? '',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
              message: 'All todos',
              child: TextButton(
                onPressed: () =>
                    dispatch(SearchCategoryAction(SearchCategory.All)),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                    primary: textColorFor(SearchCategory.All, sc)),
                child: const Text('All'),
              )),
          Tooltip(
              message: 'Only uncompleted todos',
              child: TextButton(
                onPressed: () =>
                    dispatch(SearchCategoryAction(SearchCategory.Active)),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                    primary: textColorFor(SearchCategory.Active, sc)),
                child: const Text('Active'),
              )),
          Tooltip(
              message: 'Only completed todos',
              child: TextButton(
                onPressed: () =>
                    dispatch(SearchCategoryAction(SearchCategory.Completed)),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                    primary: textColorFor(SearchCategory.Completed, sc)),
                child: const Text('Complete'),
              )),
        ],
      ),
    );
  }

  Color? textColorFor(
      SearchCategory btnCategory, SearchCategory selectedCategory) {
    return btnCategory == selectedCategory ? Colors.blue : Colors.black;
  }
}
