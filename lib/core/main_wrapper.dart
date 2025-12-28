import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/core/theme/app_colors.dart';

class MainWrapper extends StatefulWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location == '/stats') return 1;
    return 0;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/stats'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: widget.child,

      floatingActionButton: SizedBox(
        height: 65, width: 65,
        child: FloatingActionButton(
          onPressed: () => context.push('/add'),
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(
                  icon: Icons.home_filled,
                  isSelected: selectedIndex == 0,
                  onTap: () => _onItemTapped(0)
              ),
              _NavIcon(
                  icon: Icons.bar_chart,
                  isSelected: selectedIndex == 1,
                  onTap: () => _onItemTapped(1)
              ),
              const SizedBox(width: 48),
              _NavIcon(icon: Icons.account_balance_wallet, isSelected: false, onTap: () {}),
              _NavIcon(icon: Icons.person_outline, isSelected: false, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, size: 28, color: isSelected ? AppColors.primary : Colors.grey[300]),
    );
  }
}
