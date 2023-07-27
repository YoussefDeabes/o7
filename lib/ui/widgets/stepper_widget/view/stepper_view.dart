import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/stepper_widget/model/stepper_item.dart';
import 'package:o7therapy/ui/widgets/stepper_widget/view_model/stepper_view_model.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class StepperView extends StatefulWidget {
  /// required to build steps
  final List<StepperItem> steps;

  /// Returns active step
  final Function(int page)? onStepChanged;

  /// set the header color
  final Color? headerColor;

  /// set the progress indicator color
  final Color? progressColor;

  /// sets headers text style
  final TextStyle? headerStyle;

  /// sets progresses text style
  final TextStyle? progressStyle;

  /// sets headers height
  final double? headerHeight;

  /// sets headers bottom controllers height
  final double? controllerHeight;

  /// sets headers animation duration
  final Duration? headerAnimationDuration;

  /// sets progress bar animation duration
  final Duration? progressBarAnimationDuration;

  /// sets bottom controller
  final Widget Function(Function() onNextTapped, Function() onBackTapped)?
      controlBuilder;

  const StepperView(
      {Key? key,
      required this.steps,
      this.onStepChanged,
      this.headerColor,
      this.headerStyle,
      this.progressStyle,
      this.headerAnimationDuration,
      this.progressBarAnimationDuration,
      this.controlBuilder,
      this.progressColor,
      this.headerHeight,
      this.controllerHeight})
      : super(key: key);

  @override
  State<StepperView> createState() => _StepperViewState();
}

class _StepperViewState extends State<StepperView>
    with TickerProviderStateMixin, Translator {
  late final StepperViewModel _viewModel;
  late final Animation<double> textAnimation;
  late final AnimationController _controller, _circleValue;
  late final double ratio;
  Map<int, String> steeperIndex = {};

  @override
  void initState() {
    super.initState();

    _viewModel = StepperViewModel();
    _controller = AnimationController(
      duration:
          widget.headerAnimationDuration ?? const Duration(milliseconds: 250),
      vsync: this,
    );
    _circleValue = AnimationController(
      duration:
          widget.progressBarAnimationDuration ?? const Duration(seconds: 1),
      vsync: this,
    );
    textAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
    Future.delayed(Duration.zero, () {
      steeperIndex = {
        1: translate(LangKeys.one),
        2: translate(LangKeys.two),
        3: translate(LangKeys.three),
        4: translate(LangKeys.four),
        5: translate(LangKeys.five),
      };
    });
    _circleValue.addListener(() {
      setState(() {});
    });

    ratio = 1 / widget.steps.length;

    Future.delayed(const Duration(milliseconds: 500))
        .whenComplete(() => _circleValue.animateTo(ratio));
  }

  @override
  void dispose() {
    _controller.dispose();
    _circleValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Column(
      children: [
        buildTop(),
        Expanded(child: buildCenter()),
        buildBottom(),
      ],
    );
  }

  Container buildTop() {
    final double height = widget.headerHeight ?? 70;

    return Container(
      height: height,
      padding: const EdgeInsets.only(left: 12, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Observer(builder: (_) {
            return  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                      color: ConstColors.app,
                    ));
          }),
          Row(
            children: [
              Container(
                height: height,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Observer(builder: (_) {
                  return Center(
                    child: Text(
                      '${translate(LangKeys.step)} ${steeperIndex[_viewModel.currentStep + 1]}  ',
                      style: widget.progressStyle,
                    ),
                  );
                }),
              ),
              SizedBox(
                height: height,
                child: Center(
                  child: Text(
                    //widget.steps.length
                    '—  ${translate(LangKeys.stepsLengths)}  ',
                    style:
                        const TextStyle(color: ConstColors.text, fontSize: 16),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildCenter() => Observer(builder: (_) {
        return widget.steps[_viewModel.currentStep].content;
      });

  Widget buildBottom() {
    if (widget.controlBuilder != null) {
      return widget.controlBuilder!(() {
        tap(true);
      }, () {
        tap(false);
      });
    } else {
      return defaultController();
    }
  }

  Widget defaultController() {
    final double height = widget.controllerHeight ?? 70;
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => tap(false),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              height: height,
              alignment: Alignment.center,
              child: Text(
                'Back',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            onTap: () => tap(true),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
              ),
              height: height,
              alignment: Alignment.center,
              child: Text(
                'Next',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  tap(bool isIncrement) {
    isIncrement
        ? _circleValue.animateTo(_circleValue.value + ratio)
        : _circleValue.animateTo(_circleValue.value - ratio);
    _controller.forward().whenComplete(() {
      isIncrement ? _viewModel.incrementStep() : _viewModel.decrementStep();

      if (widget.onStepChanged != null) {
        widget.onStepChanged!(_viewModel.currentStep);
      }
      _controller.reverse();
    });
  }
}
