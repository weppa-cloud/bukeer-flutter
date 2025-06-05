#!/usr/bin/env python3
"""
Final migration script for remaining allData* references.
"""

import os
import re
import glob

def migrate_passenger_references():
    """Migrate FFAppState().allDataPassenger to ItineraryService."""
    passenger_file = 'lib/bukeer/itinerarios/pasajeros/modal_add_passenger/modal_add_passenger_widget.dart'
    
    if not os.path.exists(passenger_file):
        print(f"❌ File not found: {passenger_file}")
        return False
    
    try:
        with open(passenger_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Add ItineraryService import if needed
        if 'import \'../../../../services/itinerary_service.dart\';' not in content:
            # Find the last import line
            lines = content.split('\n')
            last_import_line = -1
            
            for i, line in enumerate(lines):
                if line.strip().startswith('import ') and line.strip().endswith(';'):
                    last_import_line = i
            
            if last_import_line != -1:
                lines.insert(last_import_line + 1, 'import \'../../../../services/itinerary_service.dart\';')
                content = '\n'.join(lines)
        
        # Replace FFAppState().allDataPassenger with ItineraryService
        content = re.sub(
            r'FFAppState\(\)\.allDataPassenger',
            'context.read<ItineraryService>().allDataPassenger',
            content
        )
        
        # Write the updated content
        with open(passenger_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Migrated {passenger_file}")
        return True
        
    except Exception as e:
        print(f"❌ Error migrating {passenger_file}: {e}")
        return False

def count_remaining_references():
    """Count remaining allData* references."""
    print("\n🔍 Counting remaining allData* references...")
    
    # FFAppState references
    result = os.popen('cd "/Users/yeisongomez/Documents/Clude Code/bukeerweb/bukeer" && grep -r "FFAppState().allData" lib/ --include="*.dart" | wc -l').read().strip()
    ffapp_count = int(result) if result.isdigit() else 0
    
    # UiStateService references (these might need migration too)
    result = os.popen('cd "/Users/yeisongomez/Documents/Clude Code/bukeerweb/bukeer" && grep -r "UiStateService().allData" lib/ --include="*.dart" | wc -l').read().strip()
    ui_count = int(result) if result.isdigit() else 0
    
    print(f"   FFAppState().allData* references: {ffapp_count}")
    print(f"   UiStateService().allData* references: {ui_count}")
    print(f"   Total: {ffapp_count + ui_count}")
    
    return ffapp_count + ui_count

def main():
    """Main migration function."""
    print("🚀 Starting final allData* migration...")
    
    # Migrate passenger references
    migrate_passenger_references()
    
    # Count remaining references
    remaining_count = count_remaining_references()
    
    if remaining_count > 0:
        print(f"\n⚠️  Still {remaining_count} allData* references remaining")
        print("   These may be intentional (like allDataAccount in UserService)")
        print("   or require manual migration.")
        
        # Show the remaining references
        print("\n📋 Remaining references:")
        os.system('cd "/Users/yeisongomez/Documents/Clude Code/bukeerweb/bukeer" && grep -r "FFAppState().allData" lib/ --include="*.dart"')
    else:
        print("✅ All allData* references have been migrated!")
    
    print(f"\n✅ Final migration completed!")

if __name__ == "__main__":
    main()