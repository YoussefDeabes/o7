import 'package:flutter/cupertino.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SaveCardButton extends BaseStatelessWidget {
  final bool isCardSaved;
  final void Function(bool)? onSaveChanged;
  SaveCardButton({
    required this.isCardSaved,
    required this.onSaveChanged,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: width / 14,
          child: Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
              value: isCardSaved,
              activeColor: ConstColors.app,
              onChanged: onSaveChanged,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          translate(LangKeys.saveCard),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ConstColors.textSecondary),
        )
      ],
    );
  }
}
