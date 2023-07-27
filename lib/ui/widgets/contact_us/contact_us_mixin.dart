import 'dart:io';

import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:url_launcher/url_launcher.dart';

part 'contact_us_mode_bottom_sheet_widget.dart';

/// this contact us used in (more screen for logged in user - more screen for the gust user)
mixin ContactUsMixin {
  // get Modal Bottom Sheet for contact us
  Future<void> getContactUsOnPressed(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      builder: (BuildContext context) => _ContactUsModelBottomSheetWidget(),
    );
  }
}
