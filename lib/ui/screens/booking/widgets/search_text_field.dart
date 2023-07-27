import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_bloc.dart';
import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/filter_icon.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SearchTextField extends StatefulWidget {
  final bool? enableEditingTextFiled;
  const SearchTextField({required this.enableEditingTextFiled, super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

final TextEditingController textEditingController = TextEditingController();
final ValueNotifier<String> inputString = ValueNotifier<String>("");

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 0.053 * context.height,
        child: BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            String? newListenerValue =
                state.searchQuery[SearchBloc.searchKeyword];
            inputString.value = newListenerValue ?? "";
            textEditingController.text = newListenerValue ?? "";
          },
          child: TextField(
            enabled: widget.enableEditingTextFiled ?? true,
            style: const TextStyle(fontSize: 14.0),
            onSubmitted: (String value) {
              SearchBloc.bloc(context).add(AddSearchInputEvent(value));
            },
            controller: textEditingController,
            onChanged: (value) => inputString.value = value,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: context.translate(LangKeys.search),
              prefixIcon: ValueListenableBuilder<String>(
                valueListenable: inputString,
                builder: (context, value, _) {
                  return value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // change the ValueListenableBuilder
                            inputString.value = "";
                            textEditingController.clear();
                            SearchBloc.bloc(context)
                                .add(const ClearSearchEvent());
                          },
                        )
                      : BookingScreenIcon(
                          assetPath: AssPath.searchIcon,
                          onTap: null,
                        );
                },
              ),
              suffixIcon: const FilterIcon(),
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
        ),
      ),
    );
  }
}
