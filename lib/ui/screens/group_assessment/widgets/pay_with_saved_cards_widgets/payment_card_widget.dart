import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PaymentCardWidget extends BaseStatelessWidget {
  final int index;
  final int selectedGroupValue;
  final CreditCardData creditCardData;
  final void Function(int?)? onChanged;
  final Function(CreditCardData) onDeleteCard;

  PaymentCardWidget({
    required this.onDeleteCard,
    required this.onChanged,
    required this.index,
    required this.selectedGroupValue,
    required this.creditCardData,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio<int>(
                  activeColor: ConstColors.accentColor,
                  focusColor: ConstColors.accentColor,
                  value: index + 1,
                  groupValue: selectedGroupValue,
                  onChanged: onChanged,
                ),
                Text(
                  translate(LangKeys.endingWith) +
                      translate(LangKeys.hashedCreditCardNum) +
                      creditCardData.lastFourDigits!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: ConstColors.app),
                )
              ],
            ),
            _getCreditCardLogo(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  _getRemoveModalBottomSheet(context, index);
                },
                child: Text(
                  translate(LangKeys.delete),
                  style: const TextStyle(
                      color: ConstColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )),
            creditCardData.isPreferred! == true
                ? Text(
                    translate(LangKeys.primary),
                    style: const TextStyle(
                        color: ConstColors.textDisabled,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  )
                : Text(
                    translate(LangKeys.secondary),
                    style: const TextStyle(
                        color: ConstColors.textDisabled,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  )
          ],
        ),
        lineDivider(),
      ],
    );
  }

  Widget _getCreditCardLogo() {
    return creditCardData.brand == 1
        ? SvgPicture.asset(AssPath.visaLogo, height: 10, width: 10)
        : creditCardData.brand == 2
            ? Image.asset(AssPath.mastercardLogo, scale: 40)
            : creditCardData.brand == 3
                ? Image.asset(AssPath.amex, scale: 20)
                : const SizedBox.shrink();
  }

  _getRemoveModalBottomSheet(BuildContext context, int index) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                translate(LangKeys.deleteCard),
                style: const TextStyle(
                    color: ConstColors.app,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                translate(LangKeys.areYouSureYouWantToDeleteThisCard),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelButton(context),
                  const SizedBox(
                    width: 10,
                  ),
                  _removeButton(index, context),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _cancelButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Chip(
        backgroundColor: ConstColors.appWhite,
        side: const BorderSide(color: ConstColors.app),
        label: Text(
          translate(LangKeys.cancel),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.app,
          ),
        ),
      ),
    );
  }

  Widget _removeButton(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onDeleteCard(creditCardData);
        // context.read<CheckoutBloc>().add(DeleteCardEvent(cards[index].code!));
      },
      child: Chip(
        backgroundColor: ConstColors.app,
        label: Text(
          translate(LangKeys.remove),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.appWhite,
          ),
        ),
      ),
    );
  }
}
