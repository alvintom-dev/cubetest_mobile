import 'package:flutter/material.dart';

class TestsOverviewPage extends StatelessWidget {
  const TestsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tests')),
      body: Center(
        child: Text(
          'Coming soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
