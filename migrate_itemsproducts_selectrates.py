#!/usr/bin/env python3
import os
import re
import subprocess

# Get all files that have FFAppState references to itemsProducts and selectRates
result = subprocess.run([
    'grep', '-r', '-l', 'FFAppState()\.itemsProducts\|FFAppState()\.selectRates', 'lib/', '--include=*.dart'
], capture_output=True, text=True)

files_to_process = result.stdout.strip().split('\n') if result.stdout.strip() else []

# Remove files we want to exclude
exclude_files = ['app_state_clean.dart', 'ui_state_service.dart']
files_to_process = [f for f in files_to_process if not any(exc in f for exc in exclude_files)]

print(f"Found {len(files_to_process)} files with itemsProducts/selectRates references")

# Define replacements for itemsProducts and selectRates
replacements = [
    (r'FFAppState\(\)\.itemsProducts', 'context.read<UiStateService>().itemsProducts'),
    (r'FFAppState\(\)\.selectRates', 'context.read<UiStateService>().selectRates'),
]

files_modified = 0

for file_path in files_to_process:
    if not os.path.exists(file_path):
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
                
                # Add UiStateService import if not present
                ui_service_import = "import '../../../services/ui_state_service.dart';"
                if 'bukeer/modal_add_edit_itinerary' in file_path:
                    ui_service_import = "import '../../services/ui_state_service.dart';"
                elif 'bukeer/componentes' in file_path:
                    ui_service_import = "import '../../../services/ui_state_service.dart';"
                elif 'bukeer/contactos' in file_path:
                    ui_service_import = "import '../../../services/ui_state_service.dart';"
                elif 'bukeer/itinerarios' in file_path:
                    ui_service_import = "import '../../../../services/ui_state_service.dart';"
                elif 'bukeer/productos' in file_path:
                    ui_service_import = "import '../../../services/ui_state_service.dart';"
                elif 'bukeer/users' in file_path:
                    ui_service_import = "import '../../../services/ui_state_service.dart';"
                
                import_lines.append(ui_service_import)
                content = '\n'.join(import_lines + other_lines)
            
            with open(file_path, 'w') as f:
                f.write(content)
            
            files_modified += 1
            print(f"✅ Modified: {file_path}")
    
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")

print(f"\n🎉 Migration completed! Modified {files_modified} files.")