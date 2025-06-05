#!/usr/bin/env python3
import re

# Read the file
with open('lib/bukeer/itinerarios/servicios/dropdown_products/dropdown_products_widget.dart', 'r') as f:
    content = f.read()

# Define replacements
replacements = [
    # itemsProducts
    (r"FFAppState\(\)\.itemsProducts\s*=", 
     "context.read<UiStateService>().itemsProducts ="),
     
    # selectRates
    (r"FFAppState\(\)\.selectRates\s*=", 
     "context.read<UiStateService>().selectRates ="),
]

# Apply replacements
for old_pattern, new_pattern in replacements:
    content = re.sub(old_pattern, new_pattern, content)

# Write back
with open('lib/bukeer/itinerarios/servicios/dropdown_products/dropdown_products_widget.dart', 'w') as f:
    f.write(content)

print("✅ Fixed remaining FFAppState references in dropdown_products!")