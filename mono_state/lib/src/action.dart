class Action {
  final String type;
  Action({this.type = ''});

  @override
  String toString() => 'Action(type: $type)';
}

class RegisterStateAction extends Action {
  RegisterStateAction(String type) : super(type: type);
}

class UnregisterStateAction extends Action {
  UnregisterStateAction(String type) : super(type: type);
}

class ImportStateAction extends Action {
  ImportStateAction(String type) : super(type: type);
}
