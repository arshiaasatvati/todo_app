import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_appp/data/data.dart';
import 'package:todo_appp/data/repo/repository.dart';
import 'package:todo_appp/screens/edit/edit_screen.dart';
import 'package:todo_appp/widgets.dart';

const Color secondaryTextColor = Color(0xffafbed0);
const Color primaryColor = Color(0xff794CFF);
const Color highPriorityColor = primaryColor;
const Color normalPriorityColor = Color(0xfff09819);
const Color lowPriorityColor = Color(0xff3be1f1);

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: themeData.colorScheme.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => EditTaskScreen(task: Task()),
            ),
          );
        },
        label: Row(
          children: [
            Text('Add New Task'),
            SizedBox(width: 8),
            Icon(CupertinoIcons.add_circled),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 116,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: TextStyle(
                            color: themeData.colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.heart,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      height: 42,
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          searchKeywordNotifier.value = value;
                        },
                        style: TextStyle(fontSize: 18),
                        cursorHeight: 24,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(9),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: secondaryTextColor,
                          ),
                          hintText: 'Search tasks...',

                          hintStyle: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: themeData.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      final repository = Provider.of<Repository<Task>>(
                        context,
                        listen: false,
                      );
                      repository.deleteAll();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEAEFF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                        child: Row(
                          children: [
                            Text(
                              'Delete All',
                              style: TextStyle(color: secondaryTextColor),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              CupertinoIcons.delete,
                              color: secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return Consumer<Repository<Task>>(
                    builder: (context, repository, child) {
                      return FutureBuilder<List<Task>>(
                        future: repository.getAll(
                          searchKeyword: controller.text,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return TaskList(
                                items: snapshot.data!,
                                themeData: themeData,
                              );
                            } else {
                              return EmptyState();
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.items, required this.themeData});

  final List<Task> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80, left: 16, right: 16),
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final Task task = items[index];
        return TaskItem(themeData: themeData, task: task);
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.themeData, required this.task});

  static const double height = 75;
  static const double borderRadius = 8;

  final ThemeData themeData;
  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }

    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: widget.themeData.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(TaskItem.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCheckBox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      final repository = Provider.of<Repository<Task>>(
                        context,
                        listen: false,
                      );
                      repository.delete(widget.task);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              EditTaskScreen(task: widget.task),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 6,
              height: TaskItem.height,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(TaskItem.borderRadius),
                  bottomRight: Radius.circular(TaskItem.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
