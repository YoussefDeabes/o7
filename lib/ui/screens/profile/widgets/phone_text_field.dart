import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/validator.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final FocusNode phoneNumberFocusNode;
  final TextEditingController codeController;

  const PhoneTextField({
    required this.phoneNumberController,
    required this.phoneNumberFocusNode,
    required this.codeController,
    super.key,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String? selectedCountryFlag;
  late String selectedPhoneCode;

  @override
  void initState() {
    String initPhoneCode = widget.codeController.text;
    if (initPhoneCode.isNotEmpty) {
      widget.codeController.text = initPhoneCode;
      selectedPhoneCode = initPhoneCode;
    } else {
      Country country = CountryService().findByCode(Platform.localHostname) ??
          CountryService().findByCode("EG")!;
      widget.codeController.text = country.phoneCode;
      selectedPhoneCode = country.phoneCode;
      selectedCountryFlag = country.flagEmoji;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String Function(String) translate = AppLocalizations.of(context).translate;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _CountryCode(
          flagEmoji: selectedCountryFlag,
          phoneCode: selectedPhoneCode,
          onSelect: (country) {
            setState(() {
              selectedCountryFlag = country.flagEmoji;
              selectedPhoneCode = country.phoneCode;
              widget.codeController.text = country.phoneCode;
            });
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: widget.phoneNumberController,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            focusNode: widget.phoneNumberFocusNode,
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: ConstColors.error),
              alignLabelWithHint: true,
              label: Text(
                translate(LangKeys.asteriskPhoneNumber),
                style: const TextStyle(color: ConstColors.text),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return translate(LangKeys.emptyPhoneNumber);
              }
              if (widget.codeController.text.isEmpty) {
                return translate(LangKeys.selectCode);
              } else {
                if (Validator.validatePhoneNumber(value)) {
                  return translate(LangKeys.invalidPhoneNumber);
                } else if (value.length < 4 || value.length > 12) {
                  return translate(LangKeys.invalidPhoneNumber);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class _CountryCode extends StatelessWidget {
  final String? flagEmoji;
  final String phoneCode;
  final void Function(Country) onSelect;
  _CountryCode({
    required this.flagEmoji,
    required this.phoneCode,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCountryPicker(
          context: context,
          //Optional. Shows phone code before the country name.
          showPhoneCode: true,
          onSelect: onSelect,
          // Optional. Sets the theme for the country list picker.
          countryListTheme: CountryListThemeData(
            // Optional. Sets the border radius for the bottomsheet.
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            // Optional. Styles the search field.
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              hintText: AppLocalizations.of(context).translate(LangKeys.search),
              prefixIcon: Container(
                alignment: Alignment.center,
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  AssPath.searchIcon,
                  height: 24,
                  fit: BoxFit.fitHeight,
                ),
              ),
              border: const OutlineInputBorder(
                  gapPadding: 9.0,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  borderSide:
                      BorderSide(width: 1, color: ConstColors.disabled)),
              disabledBorder: const OutlineInputBorder(
                  gapPadding: 9.0,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  borderSide:
                      BorderSide(width: 1, color: ConstColors.disabled)),
              enabledBorder: const OutlineInputBorder(
                  gapPadding: 9.0,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  borderSide:
                      BorderSide(width: 1, color: ConstColors.disabled)),
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          flagEmoji != null
              ? Text(
                  flagEmoji!,
                  style: Theme.of(context).textTheme.headline5,
                )
              : const SizedBox.shrink(),
          Text(
            " +$phoneCode",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
