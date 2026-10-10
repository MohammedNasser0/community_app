import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
    required this.onCreate,
  });
  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0EFF7))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: 'Home',
            onPressed: () => onChanged(0),
            icon: Icon(
              index == 0 ? Icons.home_rounded : Icons.home_outlined,
              color: index == 0 ? AppTheme.primary : AppTheme.muted,
            ),
          ),
          IconButton(
            tooltip: 'Explore',
            onPressed: () => onChanged(1),
            icon: Icon(
              Icons.grid_view_rounded,
              color: index == 1 ? AppTheme.primary : AppTheme.muted,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
              ),
            ),
            child: IconButton(
              tooltip: 'Create post',
              onPressed: onCreate,
              icon: const Icon(Icons.add_box_rounded, color: Colors.white),
            ),
          ),
          IconButton(
            tooltip: 'Community Map',
            onPressed: () => onChanged(2),
            icon: Icon(
              Icons.public_outlined,
              color: index == 2 ? AppTheme.primary : AppTheme.muted,
            ),
          ),
        ],
      ),
    ),
  );
}
