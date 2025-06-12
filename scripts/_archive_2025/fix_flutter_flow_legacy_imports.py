#!/usr/bin/env python3

import os
import re
import sys

def fix_flutter_flow_legacy_imports(file_path):
    """Fix flutter_flow imports to point to legacy folder"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if file has flutter_flow imports
        if 'flutter_flow/' not in content:
            return False
        
        original_content = content
        
        # Replace patterns
        replacements = [
            # flutter_flow_theme
            ("import 'package:bukeer/flutter_flow/flutter_flow_theme.dart'", "import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart'"),
            ('import "package:bukeer/flutter_flow/flutter_flow_theme.dart"', 'import "package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart"'),
            
            # flutter_flow_util
            ("import 'package:bukeer/flutter_flow/flutter_flow_util.dart'", "import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart'"),
            ('import "package:bukeer/flutter_flow/flutter_flow_util.dart"', 'import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart"'),
            
            # flutter_flow_widgets
            ("import 'package:bukeer/flutter_flow/flutter_flow_widgets.dart'", "import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart'"),
            ('import "package:bukeer/flutter_flow/flutter_flow_widgets.dart"', 'import "package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart"'),
            
            # Other flutter_flow imports
            ("import 'package:bukeer/flutter_flow/", "import 'package:bukeer/legacy/flutter_flow/"),
            ('import "package:bukeer/flutter_flow/', 'import "package:bukeer/legacy/flutter_flow/'),
            
            # Export statements
            ("export 'package:bukeer/flutter_flow/", "export 'package:bukeer/legacy/flutter_flow/"),
            ('export "package:bukeer/flutter_flow/', 'export "package:bukeer/legacy/flutter_flow/'),
        ]
        
        for old, new in replacements:
            content = content.replace(old, new)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed flutter_flow legacy imports in: {file_path}")
            return True
        
        return False
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_and_fix_dart_files(directory):
    """Find all Dart files and fix flutter_flow imports"""
    total_files = 0
    fixed_files = 0
    
    for root, dirs, files in os.walk(directory):
        # Skip build, .dart_tool, etc.
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']
        
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                total_files += 1
                
                if fix_flutter_flow_legacy_imports(file_path):
                    fixed_files += 1
    
    print(f"\nSummary:")
    print(f"Total Dart files processed: {total_files}")
    print(f"Files with flutter_flow imports fixed to legacy: {fixed_files}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = "."
    
    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist")
        sys.exit(1)
    
    print(f"Fixing flutter_flow imports to legacy in directory: {directory}")
    find_and_fix_dart_files(directory)