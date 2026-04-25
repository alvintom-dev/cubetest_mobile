import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == navigationShell.currentIndex) return;
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}

class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <_NavItemData>[
    _NavItemData(
      label: 'Sites',
      selectedIcon: Icons.home_rounded,
      unselectedIcon: Icons.home_outlined,
    ),
    _NavItemData(
      label: 'Tests',
      selectedIcon: Icons.calendar_today_rounded,
      unselectedIcon: Icons.calendar_today_outlined,
    ),
    _NavItemData(
      label: 'Dashboard',
      selectedIcon: Icons.dashboard_rounded,
      unselectedIcon: Icons.dashboard_outlined,
    ),
    _NavItemData(
      label: 'Settings',
      selectedIcon: Icons.settings_rounded,
      unselectedIcon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary50,
      elevation: 0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary50,
          boxShadow: [
            BoxShadow(
              color: Color(0x0A322864),
              offset: Offset(0, -1),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: _NavItem(
                      data: _items[i],
                      isSelected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.primary200;
    return Semantics(
      label: data.label,
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Icon(
              isSelected ? data.selectedIcon : data.unselectedIcon,
              color: color,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
