import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class MoreScreenSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const MoreScreenSectionWidget(
      {required this.title, required this.children, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        const SizedBox(height: 24),
        _getSectionTitleTextWidget(title: title),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  /// get the title of each section
  Widget _getSectionTitleTextWidget({required String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: ConstColors.app,
      ),
    );
  }
}

class MoreScreenSectionTile extends StatelessWidget {
  const MoreScreenSectionTile({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailingIcon = true,
  }) : super(key: key);

  final String title;
  final void Function()? onTap;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: ConstColors.text,
            ),
          ),
          onTap: onTap,
          trailing: trailingIcon
              ? const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ConstColors.app,
                  size: 20,
                )
              : null,
        ),
        const Divider(),
      ],
    );
  }
}
