#!/usr/bin/env python3
import os
import re

# Define the files with issues and their fixes
fixes = [
    # main_contacts.dart issue
    {
        'file': 'lib/bukeer/contactos/main_contacts/main_contacts_widget.dart',
        'find': r'FFAppState\(\)\s*\.allDataContact\s*=\s*null;',
        'replace': 'context.read<UiStateService>().allDataContact = null;'
    },
    # main_users.dart issues
    {
        'file': 'lib/bukeer/users/main_users/main_users_widget.dart',
        'find': r'FFAppState\(\)\.allDataUser\s*=',
        'replace': 'context.read<UiStateService>().allDataUser ='
    },
    # main_products.dart issues
    {
        'file': 'lib/bukeer/productos/main_products/main_products_widget.dart',
        'find': r'FFAppState\(\)\.typeProduct\s*=',
        'replace': 'context.read<UiStateService>().selectedProductType ='
    },
    {
        'file': 'lib/bukeer/productos/main_products/main_products_widget.dart',
        'find': r'FFAppState\(\)\.searchStringState\s*=',
        'replace': 'context.read<UiStateService>().searchQuery ='
    }
]

files_modified = 0

for fix in fixes:
    file_path = fix['file']
    
    if not os.path.exists(file_path):
        print(f"⚠️ File not found: {file_path}")
        continue
        
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        original_content = content
        
        # Apply the fix
        content = re.sub(fix['find'], fix['replace'], content)
        
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
                
                # Add UiStateService import if not present
                ui_service_import = "import '../../../services/ui_state_service.dart';"
                import_lines.append(ui_service_import)
                content = '\n'.join(import_lines + other_lines)
            
            with open(file_path, 'w') as f:
                f.write(content)
            
            files_modified += 1
            print(f"✅ Fixed: {file_path}")
    
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")

print(f"\n🎉 Migration completed! Modified {files_modified} files.")