part of 'task_list_bloc.dart';

@immutable
sealed class TaskListEvent {}

final class TaskListStarted extends TaskListEvent {}

final class TaskListSearch extends TaskListEvent {
  final String searchWord;

  TaskListSearch({required this.searchWord});
}

final class TaskListDeleteAll extends TaskListEvent {}

final class TaskListDelete extends TaskListEvent {
  final Task task;

  TaskListDelete({required this.task});
}
