#!/usr/bin/env python3

import os
import re
import sys

def fix_bukeer_icon_button_imports(file_path):
    """Fix missing BukeerIconButton imports in a Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if file uses BukeerIconButton but doesn't import it
        uses_bukeer_icon_button = (
            'BukeerIconButton(' in content or 
            'BukeerIconButtonSize.' in content or 
            'BukeerIconButtonVariant.' in content
        )
        
        # Check if already has the correct import
        has_correct_import = (
            "import 'package:bukeer/design_system/components/index.dart'" in content or
            "import 'package:bukeer/design_system/components/buttons/bukeer_icon_button.dart'" in content
        )
        
        if uses_bukeer_icon_button and not has_correct_import:
            lines = content.split('\n')
            new_lines = []
            import_added = False
            
            for line in lines:
                # Add import after design_system tokens import if it exists
                if ("import 'package:bukeer/design_system/tokens/index.dart';" in line and 
                    not import_added):
                    new_lines.append(line)
                    new_lines.append("import 'package:bukeer/design_system/components/index.dart';")
                    import_added = True
                # Or add it after any other design_system import
                elif ("design_system" in line and line.strip().startswith("import") and 
                      not import_added):
                    new_lines.append(line)
                    new_lines.append("import 'package:bukeer/design_system/components/index.dart';")
                    import_added = True
                # Or add it after flutter_flow imports if no design_system import exists
                elif ("flutter_flow_theme.dart" in line and not import_added):
                    new_lines.append(line)
                    new_lines.append("import 'package:bukeer/design_system/components/index.dart';")
                    import_added = True
                else:
                    new_lines.append(line)
            
            # If we couldn't find a good place, add it at the beginning with other imports
            if not import_added:
                for i, line in enumerate(new_lines):
                    if line.strip().startswith("import") and "dart:" not in line:
                        new_lines.insert(i, "import 'package:bukeer/design_system/components/index.dart';")
                        break
            
            new_content = '\n'.join(new_lines)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Added BukeerIconButton import to: {file_path}")
            return True
        
        return False
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_and_fix_dart_files(directory):
    """Find all Dart files and fix missing BukeerIconButton imports"""
    total_files = 0
    fixed_files = 0
    
    for root, dirs, files in os.walk(directory):
        # Skip build, .dart_tool, etc.
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']
        
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                total_files += 1
                
                if fix_bukeer_icon_button_imports(file_path):
                    fixed_files += 1
    
    print(f"\nSummary:")
    print(f"Total Dart files processed: {total_files}")
    print(f"Files with missing BukeerIconButton imports fixed: {fixed_files}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = "lib"
    
    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist")
        sys.exit(1)
    
    print(f"Fixing missing BukeerIconButton imports in directory: {directory}")
    find_and_fix_dart_files(directory)