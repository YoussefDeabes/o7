import 'package:flutter/material.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SearchContactsTextField extends StatefulWidget {
  const SearchContactsTextField({super.key});

  @override
  State<SearchContactsTextField> createState() =>
      _SearchContactsTextFieldState();
}

class _SearchContactsTextFieldState extends State<SearchContactsTextField>
    with Translator {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14.0),
        onSubmitted: (String value) {
          SearchContactsBloc.bloc(context)
              .add(AddSearchContactsInputEvent(value));
        },
        onChanged: (value) {
          setState(() {});

          SearchContactsBloc.bloc(context)
              .add(AddSearchContactsInputEvent(value));
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: translate(LangKeys.search),
          prefixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // change the ValueListenableBuilder
                    setState(() {
                      controller.text = "";
                    });
                    SearchContactsBloc.bloc(context)
                        .add(const ClearSearchContactsEvent());
                  },
                )
              : BookingScreenIcon(
                  assetPath: AssPath.searchIcon,
                  onTap: null,
                ),
          border: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
          disabledBorder: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
          enabledBorder: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
        ),
      ),
    );
  }
}
