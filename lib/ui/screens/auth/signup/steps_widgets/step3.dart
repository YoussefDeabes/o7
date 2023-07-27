import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/bloc/lang/language_cubit.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';

/// step 3 : get the user age
// ignore: must_be_immutable
class StepThree extends BaseStatefulWidget {
  const StepThree({Key? key})
      : super(
          key: key,
          backGroundColor: Colors.transparent,
        );

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _StepThreeState();
}

class _StepThreeState extends BaseState<StepThree> {
  final TextEditingController _dateController = TextEditingController();

  DateTime? firstselectedDate = null;
  DateTime? newSelectedDateOfBirth ;
  // String languageCode ='en';

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _updateDateControllerText(context.read<AuthBloc>().getUserBirthDate);
     // languageCode = context.read()<LanguageCubit>().state.languageCode;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        TwoColoredHeaderText(
            firstColoredText: "${translate(LangKeys.date)} ",
            secondColoredText: translate(LangKeys.ofBirth)),
        _getAgeDatePicker(),
      ],
    );
  }
  Widget _getAgeDatePicker() {
    return InkWell(
      onTap: () => _openBottomSheetSelectDate(),
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.2, left: 54, right: 54),
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration:const InputDecoration(
              alignLabelWithHint: true,
              hintText:"dd/mm/yyyy" ,
              hintStyle: TextStyle(
                  color: ConstColors.textGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
              errorStyle:  TextStyle(color: ConstColors.error),
            ),
            controller: _dateController,
            onSaved: (value) {},
            validator: (value) {
              if (_dateController.text == null ||
                  _dateController.text.isEmpty) {
                return translate(LangKeys.ageEmptyErr);
              }
            },
          ),
        ),
      ),
    );
  }
  _openBottomSheetSelectDate()async{
    AuthBloc authBloc = context.read<AuthBloc>();
    DateTime selectedDate =
        firstselectedDate ?? authBloc.getDateTimeBefore18Years;
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
      builder: (BuildContext context) => SizedBox(
        height: 300,
        child: Column(children: [
          const SizedBox(height:30,),
          SizedBox(
            width: height*0.35,
            child: DatePickerWidget(
              initialDate: selectedDate,
              firstDate: authBloc.getDateTimeBefore18Years
                  .subtract(const Duration(days: 365 * 100)),
              lastDate: authBloc.getDateTimeBefore18Years,
              dateFormat: "MMM-dd-yyyy",
              pickerTheme:const DateTimePickerTheme(
                itemHeight: 50,
                backgroundColor: Colors.white,
                dividerColor: ConstColors.disabled,
                itemTextStyle: TextStyle(color: ConstColors.app,fontWeight: FontWeight.w600,fontSize: 16),),

              onChange: ((DateTime date, list) {
                newSelectedDateOfBirth = date;
              }),
            ),
          ),

          const SizedBox(height: 10,),
          CustomRoundedButton(onPressed: (){
            _onDoneSelectedDateOfBirthClicked();
          }, text:translate(LangKeys.done), widthValue: width*0.7),
          const SizedBox(height: 10,),
        ],),
      ),
    );
  }
  _onDoneSelectedDateOfBirthClicked(){
    AuthBloc authBloc = context.read<AuthBloc>();

    DateTime selectedDate =
        firstselectedDate ?? authBloc.getDateTimeBefore18Years;

    if (newSelectedDateOfBirth != null && newSelectedDateOfBirth != selectedDate) {
      setState(() {
        selectedDate = newSelectedDateOfBirth!;
        firstselectedDate = newSelectedDateOfBirth;
        _updateDateControllerText(selectedDate);
        authBloc.add(BirthDateChangedEvent(newSelectedDateOfBirth!));
      });
    }
    Navigator.pop(context);
  }

  /// update the date controller text
  void _updateDateControllerText(DateTime? date) {
    if (date != null) {
      _dateController.text = DateFormat.yMMMd().format(date);
    }
  }

}
