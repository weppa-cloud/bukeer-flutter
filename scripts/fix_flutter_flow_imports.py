#!/usr/bin/env python3

import os
import re
import sys

def fix_flutter_flow_imports(file_path):
    """Fix relative flutter_flow imports to use package imports"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if file has relative flutter_flow imports
        if '../flutter_flow/' not in content and '../../flutter_flow/' not in content:
            return False
        
        original_content = content
        
        # Patterns to replace
        patterns = [
            # Various levels of relative imports
            (r"import '\.\./\.\./(\.\./)*(flutter_flow/[^']+)'", r"import 'package:bukeer/\2'"),
            (r'import "\.\./\.\./(\.\./)*(flutter_flow/[^"]+)"', r'import "package:bukeer/\2"'),
            # Export statements
            (r"export '\.\./\.\./(\.\./)*(flutter_flow/[^']+)'", r"export 'package:bukeer/\2'"),
            (r'export "\.\./\.\./(\.\./)*(flutter_flow/[^"]+)"', r'export "package:bukeer/\2"'),
        ]
        
        for pattern, replacement in patterns:
            content = re.sub(pattern, replacement, content)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed flutter_flow imports in: {file_path}")
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
                
                if fix_flutter_flow_imports(file_path):
                    fixed_files += 1
    
    print(f"\nSummary:")
    print(f"Total Dart files processed: {total_files}")
    print(f"Files with flutter_flow imports fixed: {fixed_files}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = "lib"
    
    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist")
        sys.exit(1)
    
    print(f"Fixing flutter_flow imports in directory: {directory}")
    find_and_fix_dart_files(directory)