import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taskbuddies/app/locator.dart';
import 'package:taskbuddies/models/todo_list.dart';
import 'package:taskbuddies/services/bottom_sheet_service.dart';

@lazySingleton
class TodoListViewModel extends BaseViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final List<TodoList> todoLists = [];
  final DateTime timeStamp = DateTime.now();

  bool areListsAvailable() {
    return todoLists.isEmpty;
  }

  void deleteList(TodoList listToDelete) async {
    var result = await _dialogService.showConfirmationDialog(
        description: 'Tap Ok to delete your list',
        title: 'Are you sure you want to delete "${listToDelete.title}"');
    if (result.confirmed) {
      this.todoLists.removeWhere((element) {
        return listToDelete.title == element.title;
      });
      notifyListeners();
    }
  }

  void completeTask(Todo item, TodoList list) {
    list.completeItem(item);
    _snackBarService.showSnackbar(message: '${item.item} is complete!');
    notifyListeners();
  }

  void addItem(TodoList todoList) async {
    var newItem = await _bottomSheetService.showBottomSheet(
        description: 'Add a new Item', toggle: true);
    todoList.addNewItem(newItem.fieldOne);
    notifyListeners();
  }

  void addNewList() async {
    var newItem = await _bottomSheetService.showBottomSheet(
        description: 'add description', title: 'add title', toggle: false);
    todoLists.add(TodoList(
        timeStamp: timeStamp,
        complete: [],
        incomplete: [],
        isListComplete: false,
        title: newItem.fieldTwo,
        description: newItem.fieldOne));
    notifyListeners();
  }
}
