import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;

  const EmptyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text('Content area is empty for now'),
        ],
      ),
    );
  }
}
