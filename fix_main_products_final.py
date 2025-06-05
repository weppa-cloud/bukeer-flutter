#!/usr/bin/env python3
import re

# Read the file
with open('lib/bukeer/productos/main_products/main_products_widget.dart', 'r') as f:
    content = f.read()

# Define replacements
replacements = [
    # FFAppState().typeProduct = 
    (r"FFAppState\(\)\s*\.typeProduct\s*=", 
     "context.read<UiStateService>().selectedProductType ="),
     
    # FFAppState().searchStringState =
    (r"FFAppState\(\)\s*\.searchStringState\s*=", 
     "context.read<UiStateService>().searchQuery ="),
]

# Apply replacements
for old_pattern, new_pattern in replacements:
    content = re.sub(old_pattern, new_pattern, content)

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

# Write back
with open('lib/bukeer/productos/main_products/main_products_widget.dart', 'w') as f:
    f.write(content)

print("✅ Fixed main_products FFAppState references!")