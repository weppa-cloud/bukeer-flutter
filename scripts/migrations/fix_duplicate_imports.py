#!/usr/bin/env python3

import os
import re
import sys

def fix_duplicate_imports(file_path):
    """Fix duplicate imports in a Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Track if any changes were made
        changed = False
        
        # Remove duplicate design_system imports
        lines = content.split('\n')
        new_lines = []
        seen_imports = set()
        
        for line in lines:
            line_stripped = line.strip()
            
            # Handle design_system imports - standardize to package import
            if "design_system" in line and line_stripped.startswith("import"):
                # Convert any design_system import to package form
                if "package:bukeer/design_system" not in line:
                    # Convert relative imports to package imports
                    if "../../../../design_system/index.dart" in line:
                        standardized_import = "import 'package:bukeer/design_system/tokens/index.dart';"
                    elif "../../design_system" in line:
                        standardized_import = "import 'package:bukeer/design_system/tokens/index.dart';"
                    elif "../design_system" in line:
                        standardized_import = "import 'package:bukeer/design_system/tokens/index.dart';"
                    elif "/design_system" in line:
                        standardized_import = "import 'package:bukeer/design_system/tokens/index.dart';"
                    else:
                        standardized_import = line
                    changed = True
                else:
                    standardized_import = line
                
                # Only add if we haven't seen this import before
                if standardized_import not in seen_imports:
                    new_lines.append(standardized_import)
                    seen_imports.add(standardized_import)
                else:
                    changed = True  # Skip duplicate
            else:
                new_lines.append(line)
        
        if changed:
            new_content = '\n'.join(new_lines)
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Fixed imports in: {file_path}")
            return True
        
        return False
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_and_fix_dart_files(directory):
    """Find all Dart files and fix duplicate imports"""
    total_files = 0
    fixed_files = 0
    
    for root, dirs, files in os.walk(directory):
        # Skip build, .dart_tool, etc.
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']
        
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                total_files += 1
                
                if fix_duplicate_imports(file_path):
                    fixed_files += 1
    
    print(f"\nSummary:")
    print(f"Total Dart files processed: {total_files}")
    print(f"Files with duplicate imports fixed: {fixed_files}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = "lib"
    
    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist")
        sys.exit(1)
    
    print(f"Fixing duplicate imports in directory: {directory}")
    find_and_fix_dart_files(directory)