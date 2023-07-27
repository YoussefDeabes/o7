import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/back_button_for_app_bar_more_screens.dart';

class AppBarForMoreScreens extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color color;
  final double height;

  const AppBarForMoreScreens({
    super.key,
    this.color = ConstColors.scaffoldBackground,
    required this.title,
    this.height = 56,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: color,
            boxShadow: [
              BoxShadow(
                  color: ConstColors.textGrey.withOpacity(0.2),
                  offset:const Offset(0, 0),
                  blurRadius: 6,
                  spreadRadius: 2)
            ],
          // border: Border(bottom: BorderSide(color: ConstColors.textGrey.withOpacity(0.5)))
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: BackButtonForAppBarMoreScreens(),
            ),
            Align(
              alignment: AlignmentDirectional.center,
              child: _getTitle(),
            ),
          ],
        ),
      ),
    );
  }

  /// get the title of the app bar
  Widget _getTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: ConstColors.app,
      ),
    );
  }
}
