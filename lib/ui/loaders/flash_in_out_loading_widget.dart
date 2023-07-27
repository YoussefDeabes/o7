import 'package:flutter/material.dart';

typedef FuncReturnWidget = Widget Function();

const assetMessage = 'You should specify either a itemWidget or a color '
    'to use flash in out loading';

class FlashInOutLoadingWidget extends StatefulWidget {
  final Color? color;
  final double size;
  final FuncReturnWidget? itemWidget;
  final Duration duration;
  final AnimationController? controller;

  const FlashInOutLoadingWidget({
    Key? key,
    this.color,
    this.size = 65.0,
    this.itemWidget,
    this.duration = const Duration(milliseconds: 2000),
    this.controller,
  })  : assert(
            !(itemWidget is FuncReturnWidget && color is Color) &&
                !(itemWidget == null && color == null),
            assetMessage),
        super(key: key);

  @override
  _FlashInOutLoadingWidgetState createState() =>
      _FlashInOutLoadingWidgetState();
}

class _FlashInOutLoadingWidgetState extends State<FlashInOutLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _animation = Tween(begin: -1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCirc));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: List.generate(2, (i) {
          return Transform.scale(
            scale: (1.0 - i - _animation.value.abs()).abs(),
            child: SizedBox.fromSize(
                size: Size.square(100), child: _itemBuilder(i)),
          );
        }),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemWidget != null ? widget.itemWidget!() : _defaultWidget();
  }

  /// return a circle shape for the default widget
  Widget _defaultWidget() => DecoratedBox(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: widget.color!.withOpacity(0.6)));
}
