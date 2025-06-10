import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/navigation/mobile_nav/mobile_nav_widget.dart';
import 'package:bukeer/design_system/index.dart';

WidgetbookComponent getMobileNavUseCases() {
  return WidgetbookComponent(
    name: 'MobileNav',
    useCases: [
      WidgetbookUseCase(
        name: 'Default Navigation',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: context.knobs.list(
            label: 'Selected Tab',
            options: [0, 1, 2, 3, 4],
            labelBuilder: (index) => _getTabLabel(index),
            initialOption: 0,
          ),
          iconStyle: context.knobs.list(
            label: 'Icon Style',
            options: ['Outlined', 'Filled'],
            initialOption: 'Outlined',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dashboard Selected',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 0,
          iconStyle: 'Outlined',
        ),
      ),
      WidgetbookUseCase(
        name: 'My Team Selected',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 1,
          iconStyle: 'Outlined',
        ),
      ),
      WidgetbookUseCase(
        name: 'Customers Selected',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 2,
          iconStyle: 'Outlined',
        ),
      ),
      WidgetbookUseCase(
        name: 'Contracts Selected',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 3,
          iconStyle: 'Outlined',
        ),
      ),
      WidgetbookUseCase(
        name: 'Profile Selected',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 4,
          iconStyle: 'Outlined',
        ),
      ),
      WidgetbookUseCase(
        name: 'Filled Icons Style',
        builder: (context) => _MobileNavWrapper(
          selectedIndex: 0,
          iconStyle: 'Filled',
        ),
      ),
    ],
  );
}

String _getTabLabel(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'My Team';
    case 2:
      return 'Customers';
    case 3:
      return 'Contracts';
    case 4:
      return 'Profile';
    default:
      return 'Unknown';
  }
}

class _MobileNavWrapper extends StatelessWidget {
  final int selectedIndex;
  final String iconStyle;

  const _MobileNavWrapper({
    required this.selectedIndex,
    required this.iconStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForIndex(selectedIndex),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getTabLabel(selectedIndex),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tab ${selectedIndex + 1} of 5',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MobileNavWidget(
        iconOne: _buildIcon(0, Icons.dashboard, Icons.dashboard_outlined),
        iconTwo: _buildIcon(2, Icons.people, Icons.people_outline),
        iconThree: _buildIcon(3, Icons.article, Icons.article_outlined),
        iconFour: _buildIcon(4, Icons.person, Icons.person_outline),
        iconFive: _buildIcon(1, Icons.groups, Icons.groups_outlined),
      ),
    );
  }

  Widget _buildIcon(int index, IconData filledIcon, IconData outlinedIcon) {
    final isSelected = selectedIndex == index;
    final useFilledIcons = iconStyle == 'Filled';

    return Icon(
      isSelected || useFilledIcons ? filledIcon : outlinedIcon,
      color: isSelected ? BukeerColors.primary : BukeerColors.textSecondary,
      size: 24.0,
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.groups;
      case 2:
        return Icons.people;
      case 3:
        return Icons.article;
      case 4:
        return Icons.person;
      default:
        return Icons.home;
    }
  }
}
