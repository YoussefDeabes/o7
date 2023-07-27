import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';

import 'package:o7therapy/ui/screens/auth/signup/widgets/age_and_nick_name_text_form_field.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// step 1 :: write the user name
// ignore: must_be_immutable
class StepOne extends BaseStatelessWidget {
  StepOne({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        TwoColoredHeaderText(
            firstColoredText: translate(LangKeys.lets),
            secondColoredText: translate(LangKeys.getToKnowYou)),
        _getUsernameTextField(context),
      ],
    );
  }

  //Get username/nickname text field
  Widget _getUsernameTextField(BuildContext context) {
    AuthBloc authBloc = context.watch<AuthBloc>();
    return AgeAndNickNameTextFormField(
      onChanged: (value) => authBloc.add(NickNameChangedEvent(value)),
      labelText: translate(LangKeys.nameNickname),
      initialValue: authBloc.getUserName,
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return translate(LangKeys.nameNicknameEmptyErr);
        }
      },
    );
  }
}
