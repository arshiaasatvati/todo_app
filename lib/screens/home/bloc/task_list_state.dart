part of 'task_list_bloc.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListLoading extends TaskListState {}

final class TaskListSuccess extends TaskListState {
  final List<Task> items;

  TaskListSuccess({required this.items});
}

final class TaskListEmpty extends TaskListState {}

final class TaskListError extends TaskListState {
  final String errorMessage;

  TaskListError({required this.errorMessage});
}
