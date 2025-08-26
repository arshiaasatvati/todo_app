import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_appp/screens/home/home_screen.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const CustomCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 16),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? primaryColor : null,
          borderRadius: BorderRadius.circular(12),
          border: value
              ? null
              : Border.all(width: 2, color: secondaryTextColor),
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 14,
              )
            : null,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/empty_state.svg', width: 160),
        SizedBox(height: 8),
        Text('Your Task List Is Empty...'),
      ],
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            // ignore: deprecated_member_use
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CheckBoxShape(value: isSelected, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _CheckBoxShape({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
