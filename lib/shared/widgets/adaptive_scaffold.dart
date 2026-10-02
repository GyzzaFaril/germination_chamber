import 'package:flutter/material.dart';
import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Item destinasi navigasi untuk AdaptiveScaffold
class AdaptiveNavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AdaptiveNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Scaffold adaptif yang otomatis berubah antara:
/// - Desktop (Windows): Navigation Rail / Sidebar permanen di sebelah kiri
/// - Mobile / Layar Vertikal (Android): Navigation Bar di bagian bawah
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<AdaptiveNavigationDestination> destinations;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    required this.destinations,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDesktop) {
      return Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              leading: Padding(
                padding: AppSpacing.paddingVerticalMd,
                child: Icon(
                  Icons.memory_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.map((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}
