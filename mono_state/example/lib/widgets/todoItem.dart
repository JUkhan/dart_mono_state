import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos/hooks/useDispatch.dart';
import '../states/todo.dart';

class TodoItem extends HookWidget {
  final Todo todo;
  const TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final textFieldFocusNode = useFocusNode();
    final itemFocusNode = useFocusNode();
    final textEditingController = useTextEditingController();
    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.description;
          } else if (textEditingController.text != todo.description) {
            dispatch(UpdateTodoAction(
                todo.copyWith(description: textEditingController.text)));
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
              value: todo.completed,
              onChanged: (value) =>
                  dispatch(UpdateTodoAction(todo.copyWith(completed: value)))),
          title: itemFocusNode.hasFocus
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),
        ),
      ),
    );
  }
}
