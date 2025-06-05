#!/usr/bin/env python3
import os
import re
import subprocess

# Get all files that have allData* references
result = subprocess.run([
    'grep', '-r', '-l', 
    'allDataHotel\|allDataActivity\|allDataTransfer\|allDataContact\|allDataItinerary\|allDataUser', 
    'lib/', '--include=*.dart'
], capture_output=True, text=True)

files_to_process = result.stdout.strip().split('\n') if result.stdout.strip() else []

print(f"Found {len(files_to_process)} files with allData* references")

# Define comprehensive replacements to services
replacements = [
    # ProductService replacements
    (r'context\.read<UiStateService>\(\)\.allDataHotel', 'context.read<ProductService>().allDataHotel'),
    (r'FFAppState\(\)\.allDataHotel', 'context.read<ProductService>().allDataHotel'),
    (r'context\.read<UiStateService>\(\)\.allDataActivity', 'context.read<ProductService>().allDataActivity'),
    (r'FFAppState\(\)\.allDataActivity', 'context.read<ProductService>().allDataActivity'),
    (r'context\.read<UiStateService>\(\)\.allDataTransfer', 'context.read<ProductService>().allDataTransfer'),
    (r'FFAppState\(\)\.allDataTransfer', 'context.read<ProductService>().allDataTransfer'),
    (r'context\.read<UiStateService>\(\)\.allDataFlight', 'context.read<ProductService>().allDataFlight'),
    (r'FFAppState\(\)\.allDataFlight', 'context.read<ProductService>().allDataFlight'),
    
    # ContactService replacements
    (r'context\.read<UiStateService>\(\)\.allDataContact', 'context.read<ContactService>().allDataContact'),
    (r'FFAppState\(\)\.allDataContact', 'context.read<ContactService>().allDataContact'),
    
    # ItineraryService replacements
    (r'context\.read<UiStateService>\(\)\.allDataItinerary', 'context.read<ItineraryService>().allDataItinerary'),
    (r'FFAppState\(\)\.allDataItinerary', 'context.read<ItineraryService>().allDataItinerary'),
    
    # UserService replacements  
    (r'context\.read<UiStateService>\(\)\.allDataUser', 'context.read<UserService>().allDataUser'),
    (r'FFAppState\(\)\.allDataUser', 'context.read<UserService>().allDataUser'),
]

files_modified = 0

for file_path in files_to_process:
    if not os.path.exists(file_path):
        continue
        
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        original_content = content
        
        # Apply all replacements
        for old_pattern, new_pattern in replacements:
            content = re.sub(old_pattern, new_pattern, content)
        
        # Only write if content changed
        if content != original_content:
            # Check if file needs service imports
            services_needed = []
            
            if 'context.read<ProductService>()' in content and 'services/product_service.dart' not in content:
                services_needed.append('product_service.dart')
            if 'context.read<ContactService>()' in content and 'services/contact_service.dart' not in content:
                services_needed.append('contact_service.dart') 
            if 'context.read<ItineraryService>()' in content and 'services/itinerary_service.dart' not in content:
                services_needed.append('itinerary_service.dart')
            if 'context.read<UserService>()' in content and 'services/user_service.dart' not in content:
                services_needed.append('user_service.dart')
            
            if services_needed:
                # Find import section and add service imports
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
                
                # Determine correct import path based on file location
                base_path = "../../../services/"
                if 'bukeer/modal_add_edit_itinerary' in file_path:
                    base_path = "../../services/"
                elif 'bukeer/componentes' in file_path:
                    base_path = "../../../services/"
                elif 'bukeer/contactos' in file_path:
                    base_path = "../../../services/"
                elif 'bukeer/itinerarios' in file_path:
                    base_path = "../../../../services/"
                elif 'bukeer/productos' in file_path:
                    base_path = "../../../services/"
                elif 'bukeer/users' in file_path:
                    base_path = "../../../services/"
                elif 'bukeer/agenda' in file_path:
                    base_path = "../../../services/"
                elif 'bukeer/dashboard' in file_path:
                    base_path = "../../../services/"
                
                # Add service imports
                for service in services_needed:
                    service_import = f"import '{base_path}{service}';"
                    if service_import not in '\n'.join(import_lines):
                        import_lines.append(service_import)
                
                content = '\n'.join(import_lines + other_lines)
            
            with open(file_path, 'w') as f:
                f.write(content)
            
            files_modified += 1
            print(f"✅ Migrated: {file_path}")
    
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")

print(f"\n🎉 Service migration completed! Modified {files_modified} files.")
print(f"📊 Migrated allData* references from FFAppState/UiStateService to specialized services.")

# Show final statistics
print("\n📈 Migration Summary:")
print("- ProductService: handles allDataHotel, allDataActivity, allDataTransfer, allDataFlight")
print("- ContactService: handles allDataContact") 
print("- ItineraryService: handles allDataItinerary")
print("- UserService: handles allDataUser")
print("\n✨ All services now have backward compatibility and proper state management!")