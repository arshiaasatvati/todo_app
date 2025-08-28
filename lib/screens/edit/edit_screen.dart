import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_appp/data/data.dart';
import 'package:todo_appp/data/repo/repository.dart';
import 'package:todo_appp/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todo_appp/screens/home/home_screen.dart';
import 'package:todo_appp/widgets.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: context.read<EditTaskCubit>().state.task.name,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<EditTaskCubit>().onSaveChangesClick();

          Navigator.of(context).pop();
        },
        label: Row(
          children: const [
            Text('Save Changes'),
            Icon(CupertinoIcons.check_mark, size: 18),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        onTap: () {
                          context.read<EditTaskCubit>().onPriorityChange(
                            Priority.high,
                          );
                        },
                        label: 'High',
                        color: highPriorityColor,
                        isSelected: priority == Priority.high,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        onTap: () {
                          context.read<EditTaskCubit>().onPriorityChange(
                            Priority.normal,
                          );
                        },
                        label: 'Normal',
                        color: normalPriorityColor,
                        isSelected: priority == Priority.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        onTap: () {
                          context.read<EditTaskCubit>().onPriorityChange(
                            Priority.low,
                          );
                        },
                        label: 'Low',
                        color: lowPriorityColor,
                        isSelected: priority == Priority.low,
                      ),
                    ),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChange(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text('Add a task for today...'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
