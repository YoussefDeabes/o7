import 'package:flutter/material.dart';

class TherapistProfileTabBarView extends StatelessWidget {
  final TabController _tabController;
  final List<Widget> children;

  const TherapistProfileTabBarView(
    this._tabController, {
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: _tabController, children: children);
  }
}
