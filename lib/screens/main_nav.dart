// lib/screens/main_nav_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'marketplace_screen.dart';
import 'chatbot.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Keep pages alive when switching tabs
  final List<Widget> _screens = const [
    DashboardScreen(),
    MarketplaceScreen(),
    ChatbotScreen(),
    ProfileScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      label: 'Market',
    ),
    _NavItem(
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
      label: 'AI Chat',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  void _onTap(int index) {
    if (_currentIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      // Use extendBody so screen content can reach behind the nav bar
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: _onTap,
      ),
    );
  }
}

// ─── Bottom Nav ──────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Solid opaque background — this is what was missing before
      decoration: BoxDecoration(
        color: const Color(0xFF08091A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2563FF).withOpacity(0.18),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563FF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              return Expanded(
                child: _NavButton(
                  item: items[i],
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Special treatment for the AI Chat tab (index 2)
    final isChatTab = item.label == 'AI Chat';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: isChatTab ? 48 : 40,
            height: isChatTab ? 36 : 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isChatTab ? 14 : 10),
              gradient: selected
                  ? (isChatTab
                        ? const LinearGradient(
                            colors: [Color(0xFF2563FF), Color(0xFF00CFFD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null)
                  : null,
              color: selected && !isChatTab
                  ? const Color(0xFF2563FF).withOpacity(0.18)
                  : !selected && isChatTab
                  ? const Color(0xFF2563FF).withOpacity(0.08)
                  : Colors.transparent,
            ),
            child: Icon(
              selected ? item.activeIcon : item.icon,
              size: isChatTab ? 20 : 20,
              color: selected
                  ? isChatTab
                        ? Colors.white
                        : const Color(0xFF4F8EFF)
                  : const Color(0xFF3D4F7C),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: GoogleFonts.dmSans(
              color: selected
                  ? const Color(0xFF4F8EFF)
                  : const Color(0xFF3D4F7C),
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.2,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
