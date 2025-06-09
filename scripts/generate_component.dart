#!/usr/bin/env dart
// Component generator for Bukeer project
// Usage: dart scripts/generate_component.dart [type] [name]
// Example: dart scripts/generate_component.dart button primary_action

import 'dart:io';

const Map<String, String> componentTypes = {
  'button': 'buttons',
  'form': 'forms',
  'modal': 'modals',
  'container': 'containers',
  'dropdown': 'forms/dropdowns',
  'navigation': 'navigation',
  'payment': 'payments',
};

const String coreWidgetsPath = 'lib/bukeer/core/widgets';

void main(List<String> args) {
  if (args.length < 2) {
    printUsage();
    exit(1);
  }

  final type = args[0].toLowerCase();
  final name = args[1].toLowerCase();

  if (!componentTypes.containsKey(type)) {
    print('❌ Error: Invalid component type "$type"');
    printUsage();
    exit(1);
  }

  generateComponent(type, name);
}

void printUsage() {
  print('\n📦 Bukeer Component Generator');
  print('Usage: dart scripts/generate_component.dart [type] [name]\n');
  print('Available types:');
  componentTypes.forEach((key, value) {
    print('  - $key (creates in $coreWidgetsPath/$value/)');
  });
  print(
      '\nExample: dart scripts/generate_component.dart button primary_action');
}

void generateComponent(String type, String name) {
  final componentPath = '${componentTypes[type]}';
  final componentName = '${type}_${name}';
  final className = toPascalCase(componentName);
  final widgetClassName = '${className}Widget';
  final modelClassName = '${className}Model';

  final directory = Directory('$coreWidgetsPath/$componentPath/$componentName');

  if (directory.existsSync()) {
    print('❌ Error: Component $componentName already exists!');
    exit(1);
  }

  // Create directory
  directory.createSync(recursive: true);

  // Generate widget file
  final widgetFile = File('${directory.path}/${componentName}_widget.dart');
  widgetFile.writeAsStringSync(generateWidgetContent(
      widgetClassName, modelClassName, componentName, type));

  // Generate model file
  final modelFile = File('${directory.path}/${componentName}_model.dart');
  modelFile.writeAsStringSync(
      generateModelContent(widgetClassName, modelClassName, componentName));

  // Update index.dart if it exists
  updateIndexFile(componentPath, componentName);

  print('\n✅ Component generated successfully!');
  print('📁 Location: $coreWidgetsPath/$componentPath/$componentName/');
  print('\nNext steps:');
  print('1. Implement your component logic');
  print('2. Add any required dependencies');
  print('3. Create tests in test/widgets/core/$componentPath/');
  print('4. Update documentation if needed\n');
}

String generateWidgetContent(String widgetClassName, String modelClassName,
    String componentName, String type) {
  final importPath = getImportPath(type);

  return '''import '$importPath/flutter_flow/flutter_flow_theme.dart';
import '$importPath/flutter_flow/flutter_flow_util.dart';
import '$importPath/flutter_flow/flutter_flow_model.dart';
import '$importPath/design_system/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '${componentName}_model.dart';
export '${componentName}_model.dart';

class $widgetClassName extends StatefulWidget {
  const $widgetClassName({
    super.key,
    // Add your parameters here
  });

  // Add your widget parameters as final fields here

  @override
  State<$widgetClassName> createState() => _${widgetClassName}State();
}

class _${widgetClassName}State extends State<$widgetClassName> {
  late $modelClassName _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => $modelClassName());

    // Initialize your model here
    
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Implement your widget UI here
      padding: const EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: BukeerColors.getBackground(context),
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
      ),
      child: Text(
        '$widgetClassName',
        style: FlutterFlowTheme.of(context).bodyMedium,
      ),
    );
  }
}
''';
}

String generateModelContent(
    String widgetClassName, String modelClassName, String componentName) {
  final importPath = getImportPath('');

  return '''import '$importPath/flutter_flow/flutter_flow_model.dart';
import '$importPath/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '${componentName}_widget.dart' show $widgetClassName;

class $modelClassName extends FlutterFlowModel<$widgetClassName> {
  ///  State fields for stateful widgets in this component.
  
  // Add your state fields here
  // Example:
  // bool? isLoading = false;
  // String? selectedValue;
  // TextEditingController? textController;
  // FocusNode? textFieldFocusNode;

  @override
  void initState(BuildContext context) {
    // Initialize controllers and focus nodes here
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes here
    // Example:
    // textController?.dispose();
    // textFieldFocusNode?.dispose();
  }

  /// Additional helper methods can be added here
}
''';
}

String getImportPath(String type) {
  final depth = type == 'dropdown' ? 6 : 5;
  return List.generate(depth, (_) => '..').join('/');
}

void updateIndexFile(String componentPath, String componentName) {
  final indexFile = File('$coreWidgetsPath/$componentPath/index.dart');

  if (!indexFile.existsSync()) {
    // Create index file if it doesn't exist
    indexFile.writeAsStringSync(
        '''// ${componentPath.split('/').last.toUpperCase()} Components
// Export all ${componentPath.split('/').last} components

export '$componentName/${componentName}_widget.dart';
''');
    print('📝 Created index.dart for $componentPath');
  } else {
    // Append to existing index file
    final content = indexFile.readAsStringSync();
    final exportLine = "export '$componentName/${componentName}_widget.dart';";

    if (!content.contains(exportLine)) {
      indexFile.writeAsStringSync('$content\n$exportLine');
      print('📝 Updated index.dart with new export');
    }
  }
}

String toPascalCase(String text) {
  return text
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
