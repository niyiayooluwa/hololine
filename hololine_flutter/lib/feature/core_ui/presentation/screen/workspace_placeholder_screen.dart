import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspacePlaceholderScreen extends StatelessWidget {
  final String title;

  const WorkspacePlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: ShadTheme.of(context).textTheme.h3),
    );
  }
}
