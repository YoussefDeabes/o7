import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/filter_section_header.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/price_range_section/form_or_to_section.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/price_range_section/max_numerical_range_formatter.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/price_range_section/reset_bottom_for_price_range.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// get the Price Range section to let the user choose the range of prices of the therapists
class PriceRangeSection extends StatefulWidget {
  final FilterPriceData filterPrice;
  final RangeValues currentRangeValues;
  final void Function(RangeValues)? onRangeChanged;
  final void Function()? onResetPressed;

  const PriceRangeSection({
    super.key,
    required this.onRangeChanged,
    required this.filterPrice,
    required this.currentRangeValues,
    required this.onResetPressed,
  });

  @override
  State<StatefulWidget> createState() => PriceRangeSectionState();
}

class PriceRangeSectionState extends State<PriceRangeSection> {
  /// the First value in the range user select in the range
  late int _startValue;

  /// the end value in the range user select in the range
  late int _endValue;

  /// minimum value user can reach
  late int minValue;

  /// max value user can reach
  late int maxValue;

  final startController = TextEditingController();
  final endController = TextEditingController();

  final FocusNode startFocusNode = FocusNode();
  final FocusNode endFocusNode = FocusNode();

  void reset() {
    startController.text = minValue.toInt().toString();
    endController.text = maxValue.toInt().toString();
  }

  @override
  void initState() {
    super.initState();

    _startValue = widget.currentRangeValues.start.toInt();
    _endValue = widget.currentRangeValues.end.toInt();
    minValue = widget.filterPrice.initialMinPrice.toInt();
    maxValue = widget.filterPrice.initialMaxPrice.toInt();

    startController.text = _startValue.toInt().toString();
    endController.text = _endValue.toInt().toString();

    /// same as on changed
    startController.addListener(_setStartValue);
    endController.addListener(_setEndValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    startController.removeListener(_setStartValue);
    endController.removeListener(_setEndValue);
    startController.dispose();
    endController.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
    super.dispose();
  }

  /// set the [_startValue] and [start] value in [RangeValues]
  /// from the [startController] text
  _setStartValue() {
    if (_isValidValue) {
      setState(() {
        _startValue = double.parse(startController.text).toInt();
        widget.onRangeChanged!(RangeValues(
          _startValue.toDouble(),
          _endValue.toDouble(),
        ));
      });
    }
  }

  /// set the [_endValue] and [end] value in [RangeValues]
  /// from the [endController] text
  _setEndValue() {
    if (_isValidValue) {
      setState(() {
        _endValue = double.parse(endController.text).toInt();
        widget.onRangeChanged!(RangeValues(
          _startValue.toDouble(),
          _endValue.toDouble(),
        ));
      });
    }
  }

  /// check if the value entered in the [startController] & [endController] are valid
  /// used to check >>  when to update the slider
  /// if the user entered a valid number depending on max and min and start and end
  /// then update the [slider], [start] or [end] values
  bool get _isValidValue {
    int? startValue = double.tryParse(startController.text)?.toInt();
    int? endValue = double.tryParse(endController.text)?.toInt();
    if (startValue == null || endValue == null) {
      return false;
    }
    return startValue <= endValue &&
        startValue >= minValue &&
        endValue >= minValue &&
        startValue <= maxValue &&
        endValue <= maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterSectionHeader(
                headerText: context.translate(LangKeys.priceRange),
              ),
              ResetButtonForPriceRange(
                onPressed: () {
                  widget.onResetPressed!();
                  startController.text = minValue.toInt().toString();
                  endController.text = maxValue.toInt().toString();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// From Section
              FromOrToSection(
                currency: widget.filterPrice.currency,
                controller: startController,
                focusNode: startFocusNode,
                title: context.translate(LangKeys.from),
                rangeFormatter: MaxNumericalRangeFormatter(
                  max: _endValue - 1, // must not be larger than end
                  valueForInvalidParse: minValue,
                ),
                onEditingComplete: () {
                  // when editing complete and the slider didn't updated in listener
                  // then set the text controller to previous value
                  double? editingValue = double.tryParse(startController.text);

                  ///  if the start < min then set the start to min value and update
                  if (editingValue != null && editingValue < minValue) {
                    startController.text = minValue.toInt().toString();
                  } else if (!_isValidValue) {
                    startController.text = _startValue.toInt().toString();
                  }
                  if (startFocusNode.hasPrimaryFocus) {
                    startFocusNode.unfocus();
                  }
                  // update after change
                  _setStartValue();
                },
              ),

              /// To Section
              FromOrToSection(
                currency: widget.filterPrice.currency,
                controller: endController,
                focusNode: endFocusNode,
                title: context.translate(LangKeys.to),
                rangeFormatter: MaxNumericalRangeFormatter(
                  max: maxValue, // must not be larger than max
                  valueForInvalidParse: maxValue,
                ),
                onEditingComplete: () {
                  // when editing complete and the slider didn't updated in listener
                  // then set the text controller to previous value
                  if (!_isValidValue) {
                    endController.text = _endValue.toInt().toString();
                  }
                  if (endFocusNode.hasPrimaryFocus) {
                    endFocusNode.unfocus();
                  }
                  // update after change
                  _setEndValue();
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
                child: SliderTheme(
              data: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: RangeSlider(
                activeColor: ConstColors.app,
                values: widget.currentRangeValues,
                min: minValue.toDouble(),
                max: maxValue.toDouble(),
                onChanged: (RangeValues values) {
                  setState(() {
                    _startValue = values.start.toInt();
                    _endValue = values.end.toInt();
                    startController.text = values.start.toInt().toString();
                    endController.text = values.end.toInt().toString();
                  });
                  widget.onRangeChanged!(values);
                },
              ),
            )),
          ),
        ]);
  }
}
