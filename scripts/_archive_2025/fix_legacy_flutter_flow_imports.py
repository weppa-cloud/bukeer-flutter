#!/usr/bin/env python3

import os
import re
import sys

def fix_legacy_imports(file_path):
    """Fix imports in legacy flutter_flow files to point to correct locations"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Fix imports that go up from legacy folder
        replacements = [
            # Fix imports from legacy/flutter_flow/
            ("import '../main.dart'", "import '../../main.dart'"),
            ("export '../app_state.dart'", "export '../../app_state.dart'"),
            ("import '../../main.dart'", "import '../../../main.dart'"),
            ("import '../../backend/", "import '../../../backend/"),
            ("import '../../auth/", "import '../../../auth/"),
            ("import '../../index.dart'", "import '../../../index.dart'"),
            
            # Fix exports
            ("export '../../backend/", "export '../../../backend/"),
            ("export '../../auth/", "export '../../../auth/"),
        ]
        
        for old, new in replacements:
            content = content.replace(old, new)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed legacy imports in: {file_path}")
            return True
        
        return False
    
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_and_fix_legacy_files(directory):
    """Find all Dart files in legacy/flutter_flow and fix imports"""
    total_files = 0
    fixed_files = 0
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                total_files += 1
                
                if fix_legacy_imports(file_path):
                    fixed_files += 1
    
    print(f"\nSummary:")
    print(f"Total Dart files processed in legacy: {total_files}")
    print(f"Files with imports fixed: {fixed_files}")

if __name__ == "__main__":
    legacy_dir = "lib/legacy/flutter_flow"
    
    if not os.path.exists(legacy_dir):
        print(f"Directory '{legacy_dir}' does not exist")
        sys.exit(1)
    
    print(f"Fixing imports in legacy flutter_flow directory: {legacy_dir}")
    find_and_fix_legacy_files(legacy_dir)