import 'package:mono_state/mono_state.dart';

enum SearchCategory { All, Active, Completed }

class SearchCategoryState extends StateBase<SearchCategory> {
  SearchCategoryState() : super(SearchCategory.All);

  @override
  void mapActionToState(
      SearchCategory state, Action action, emit, MonoState store) {
    if (action is SearchCategoryAction) emit(action.category);
  }
}

class SearchCategoryAction extends Action {
  final SearchCategory category;
  SearchCategoryAction(this.category);
}
