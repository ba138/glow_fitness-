import 'package:flutter/material.dart';

import '../widgets/aurora_background.dart';
import '../widgets/glass_bottom_nav.dart';
import 'dashboard_screen.dart';
import 'profilescreens/profile_screen.dart';
import 'progress_screen.dart';
import 'workouts_screen.dart';

/// Root scaffold: an aurora background, the active screen, and a floating
/// glass bottom navigation bar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _items = [
    GlassNavItem(Icons.grid_view_rounded, 'Home'),
    GlassNavItem(Icons.fitness_center_rounded, 'Workouts'),
    GlassNavItem(Icons.show_chart_rounded, 'Progress'),
    GlassNavItem(Icons.person_rounded, 'Profile'),
  ];

  static final _screens = [
    DashboardScreen(),
    const WorkoutsScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(key: ValueKey(_index), child: _screens[_index]),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: GlassBottomNav(
          items: _items,
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
