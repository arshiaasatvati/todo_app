import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_appp/data/data.dart';
import 'package:todo_appp/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final Task _task;
  final Repository<Task> _repository;
  EditTaskCubit(this._task, this._repository)
    : super(EditTaskInitial(task: _task));

  void onSaveChangesClick() {
    _repository.createOrUpdate(_task);
  }

  void onTextChange(String name) {
    _task.name = name;
  }

  void onPriorityChange(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(task: _task));
  }
}
