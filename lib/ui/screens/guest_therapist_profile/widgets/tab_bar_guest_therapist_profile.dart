import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

const EdgeInsetsDirectional _indicatorAndLabelPadding =
    EdgeInsetsDirectional.only(end: 8, top: 8, bottom: 8);

class TabBarGuestTherapistProfile extends StatelessWidget {
  final TabController _tabController;
  final String Function(String key) translate;
  final List<Widget> tabs;
  const TabBarGuestTherapistProfile(
    this._tabController, {
    required this.tabs,
    required this.translate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: kToolbarHeight,
        maxHeight: kToolbarHeight,
        child: Container(
          color: ConstColors.scaffoldBackground,
          padding: EdgeInsets.zero,
          child: ClipPath(
            clipper: const ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerStart,
              decoration: const BoxDecoration(
                color: ConstColors.appWhite,
                border: Border(
                  top: BorderSide(color: ConstColors.disabled, width: 1),
                  left: BorderSide(color: ConstColors.disabled, width: 1),
                  right: BorderSide(color: ConstColors.disabled, width: 1),
                ),
              ),
              child: SizedBox(
                child: TabBar(
                  /// the tab bar row padding
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: ConstColors.disabled,
                      width: 1,
                    ),
                    color: ConstColors.app,
                  ),
                  indicatorPadding: _indicatorAndLabelPadding,
                  labelPadding: _indicatorAndLabelPadding,
                  unselectedLabelColor: ConstColors.text,
                  labelColor: ConstColors.appWhite,
                  indicatorColor: ConstColors.appGrey,
                  indicatorWeight: 0.0,
                  automaticIndicatorColorAdjustment: false,
                  isScrollable: true,
                  controller: _tabController,
                  labelStyle: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.appWhite,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text,
                  ),
                  tabs: tabs,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCategoryTab extends StatelessWidget {
  const ProfileCategoryTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: ConstColors.disabled,
            )),
        child: Align(
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
