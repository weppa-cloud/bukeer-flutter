import 'package:flutter/material.dart';

class WidgetPreview extends StatelessWidget {
  final Widget widget;
  final String title;
  final List<Widget>? additionalWidgets;

  const WidgetPreview({
    super.key,
    required this.widget,
    required this.title,
    this.additionalWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Center(child: widget),
              if (additionalWidgets != null) ...[
                const SizedBox(height: 40),
                ...additionalWidgets!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
