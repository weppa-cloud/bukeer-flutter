#!/usr/bin/env python3
"""
Script to migrate remaining allData* references to specialized services.
This handles patterns not caught by the first migration script.
"""

import os
import re
import glob

# Mapping of remaining allData* references to their target services
additional_replacements = [
    # FFAppState allDataAccount references (these should remain as they're used by UserService)
    # We'll leave these as they are for now since UserService manages them
    
    # FFAppState allDataPassenger references - these should go to ItineraryService
    (r'FFAppState\(\)\.allDataPassenger', 'context.read<ItineraryService>().allDataPassenger'),
    
    # Parameter names in constructors/methods
    (r'this\.allDataItinerary,', 'this.allDataItinerary,'),  # Keep parameter names as-is
    
    # allDataContact assignment patterns
    (r'\.allDataContact\s*=\s*', '.allDataContact = '),
    
    # Any remaining direct property access patterns
    (r'\.allDataPassenger\s*=\s*', '.allDataPassenger = '),
]

# Files to exclude from this migration (to avoid breaking working files)
excluded_files = [
    'lib/services/user_service.dart',  # UserService manages allDataAccount
    'lib/services/ui_state_service.dart',  # Already migrated
    'lib/services/contact_service.dart',  # Already migrated
    'lib/services/product_service.dart',  # Already migrated  
    'lib/services/itinerary_service.dart',  # Already migrated
    'lib/app_state_clean.dart',  # Contains the clean FFAppState
    'lib/app_state.dart',  # Original FFAppState (backup)
]

def should_exclude_file(file_path):
    """Check if file should be excluded from migration."""
    return any(excluded in file_path for excluded in excluded_files)

def needs_service_import(content, service):
    """Check if the file needs a specific service import."""
    service_import = f"import '../../../services/{service.lower()}_service.dart';"
    service_import_alt = f"import '../../../../services/{service.lower()}_service.dart';"
    service_import_alt2 = f"import '../../services/{service.lower()}_service.dart';"
    
    return (service_import not in content and 
            service_import_alt not in content and 
            service_import_alt2 not in content)

def add_service_imports(content, services_needed):
    """Add necessary service imports to the file."""
    if not services_needed:
        return content
    
    # Find the last import statement
    import_pattern = r'^import\s+[^;]+;$'
    lines = content.split('\n')
    last_import_line = -1
    
    for i, line in enumerate(lines):
        if re.match(import_pattern, line.strip()):
            last_import_line = i
    
    if last_import_line == -1:
        return content  # No imports found, skip
    
    # Determine the correct import path depth
    if '/bukeer/' in content:
        if content.count('/bukeer/') >= 3:
            import_prefix = '../../../../services/'
        elif content.count('/bukeer/') >= 2:
            import_prefix = '../../../services/'
        else:
            import_prefix = '../../services/'
    else:
        import_prefix = './services/'
    
    # Add service imports
    new_imports = []
    for service in services_needed:
        import_line = f"import '{import_prefix}{service.lower()}_service.dart';"
        if import_line not in content:
            new_imports.append(import_line)
    
    if new_imports:
        lines.insert(last_import_line + 1, '\n'.join(new_imports))
        return '\n'.join(lines)
    
    return content

def migrate_file(file_path):
    """Migrate a single file."""
    if should_exclude_file(file_path):
        return False, "File excluded from migration"
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
        
        content = original_content
        changes_made = False
        services_needed = set()
        
        # Apply replacements
        for old_pattern, new_pattern in additional_replacements:
            if re.search(old_pattern, content):
                content = re.sub(old_pattern, new_pattern, content)
                changes_made = True
                
                # Determine which service is needed
                if 'ItineraryService' in new_pattern:
                    services_needed.add('ItineraryService')
                elif 'ContactService' in new_pattern:
                    services_needed.add('ContactService')
                elif 'ProductService' in new_pattern:
                    services_needed.add('ProductService')
                elif 'UserService' in new_pattern:
                    services_needed.add('UserService')
        
        # Add necessary imports
        if services_needed:
            content = add_service_imports(content, services_needed)
        
        # Write the file if changes were made
        if changes_made:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, f"Migrated successfully (services: {', '.join(services_needed)})"
        else:
            return False, "No changes needed"
            
    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    """Main migration function."""
    print("🚀 Starting additional allData* migration to specialized services...")
    
    # Find all Dart files
    dart_files = glob.glob('lib/**/*.dart', recursive=True)
    
    total_files = len(dart_files)
    migrated_files = 0
    errors = []
    
    print(f"📁 Found {total_files} Dart files")
    
    for file_path in sorted(dart_files):
        success, message = migrate_file(file_path)
        
        if success:
            migrated_files += 1
            print(f"✅ {file_path}: {message}")
        elif "No changes needed" not in message:
            if "File excluded" not in message:
                errors.append(f"{file_path}: {message}")
                print(f"❌ {file_path}: {message}")
    
    print(f"\n📊 Migration Summary:")
    print(f"   Total files: {total_files}")
    print(f"   Files migrated: {migrated_files}")
    print(f"   Errors: {len(errors)}")
    
    if errors:
        print(f"\n❌ Errors encountered:")
        for error in errors:
            print(f"   {error}")
    
    # Check remaining allData references
    print(f"\n🔍 Checking remaining allData* references...")
    os.system('grep -r "FFAppState().allData" lib/ --include="*.dart" | wc -l')
    
    print(f"\n✅ Additional migration completed!")

if __name__ == "__main__":
    main()