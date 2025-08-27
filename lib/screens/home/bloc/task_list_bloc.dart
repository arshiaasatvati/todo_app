import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_appp/data/data.dart';
import 'package:todo_appp/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<Task> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchWord;
        emit(TaskListLoading());
        if (event is TaskListSearch) {
          searchWord = event.searchWord;
        } else {
          searchWord = '';
        }

        try {
          final List<Task> items = await repository.getAll(
            searchKeyword: searchWord,
          );

          if (items.isNotEmpty) {
            emit(TaskListSuccess(items: items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError(errorMessage: 'خطای نامشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      } else if (event is TaskListDelete) {
        await repository.delete(event.task);
        final items = await repository.getAll(searchKeyword: '');
        if (items.isNotEmpty) {
          emit(TaskListSuccess(items: items));
        } else {
          emit(TaskListEmpty());
        }
      }
    });
  }
}
