#!/usr/bin/env python3
import os
import re

# Files with remaining issues
files_to_fix = [
    'lib/bukeer/agenda/main_agenda/main_agenda_widget.dart'
]

# Define replacements
replacements = [
    (r'FFAppState\(\)\.searchStringState', 'context.read<UiStateService>().searchQuery'),
]

files_modified = 0

for file_path in files_to_fix:
    if not os.path.exists(file_path):
        print(f"⚠️ File not found: {file_path}")
        continue
        
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        original_content = content
        
        # Apply replacements
        for old_pattern, new_pattern in replacements:
            content = re.sub(old_pattern, new_pattern, content)
        
        # Only write if content changed
        if content != original_content:
            # Check if file needs UiStateService import
            if 'context.read<UiStateService>()' in content and 'services/ui_state_service.dart' not in content:
                # Find import section and add UiStateService import
                import_lines = []
                other_lines = []
                in_imports = True
                
                for line in content.split('\n'):
                    if line.startswith('import ') and in_imports:
                        import_lines.append(line)
                    elif line.strip() == '' and in_imports and import_lines:
                        import_lines.append(line)
                    else:
                        if in_imports and import_lines:
                            in_imports = False
                        other_lines.append(line)
                
                # Add UiStateService import
                ui_service_import = "import '../../../services/ui_state_service.dart';"
                import_lines.append(ui_service_import)
                content = '\n'.join(import_lines + other_lines)
            
            with open(file_path, 'w') as f:
                f.write(content)
            
            files_modified += 1
            print(f"✅ Fixed: {file_path}")
    
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")

print(f"\n🎉 Fixed {files_modified} files.")

# Also fix the null assignment issues in edit_payment_methods
edit_payment_file = 'lib/bukeer/productos/edit_payment_methods/edit_payment_methods_widget.dart'
if os.path.exists(edit_payment_file):
    try:
        with open(edit_payment_file, 'r') as f:
            content = f.read()
        
        # Fix null assignments to non-nullable String
        content = re.sub(r'FFAppState\(\)\.namePaymentMethods\s*=\s*null;', 
                        'FFAppState().namePaymentMethods = "";', content)
        
        with open(edit_payment_file, 'w') as f:
            f.write(content)
        
        print(f"✅ Fixed null assignments in: {edit_payment_file}")
    except Exception as e:
        print(f"❌ Error fixing payment methods: {e}")