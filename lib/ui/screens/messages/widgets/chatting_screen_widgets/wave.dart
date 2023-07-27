import 'package:flutter/material.dart';

class WaveVisualizer extends StatelessWidget {
  const WaveVisualizer({
    Key? key,
    required this.columnWidth,
    this.isPaused = true,
    this.isBarVisible = true,
    this.color = Colors.black,
  }) : super(key: key);

  final double columnWidth;
  final bool isPaused;
  final bool isBarVisible;
  final Color color;

  static const List<int> duration = [2000, 1000, 500, 250, 750, 1500];
  static const double columnHeight = 32;
  static const List<double> initialHeight = [
    columnHeight / 9,
    columnHeight / 6,
    columnHeight / 3,
    columnHeight / 1.5,
    columnHeight / 0.75,
    columnHeight,
    columnHeight / 0.75,
    columnHeight / 1.5,
    columnHeight / 3,
    columnHeight / 6,
    columnHeight / 9,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: columnHeight,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  10,
                  (index) => VisualComponent(
                    width: columnWidth,
                    height: columnHeight,
                    duration: duration[index % 5],
                    initialHeight: isPaused ? initialHeight[index % 5] : null,
                    color: index % 2 == 0
                        ? color.withOpacity(0.1)
                        : color.withOpacity(0.03),
                  ),
                ),
              ),
              isBarVisible
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: double.maxFinite,
                        height: 4,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(
          height: columnHeight,
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(
                      10,
                      (index) => VisualComponent(
                        width: columnWidth,
                        height: columnHeight,
                        duration: duration[index % 5],
                        initialHeight:
                            isPaused ? initialHeight[index % 5] : null,
                        color: index % 2 == 0 ? color : color.withOpacity(0.3),
                      ),
                    ),
                  ),
                  isBarVisible
                      ? Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: double.maxFinite,
                            height: 4,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VisualComponent extends StatefulWidget {
  const VisualComponent({
    Key? key,
    required this.duration,
    required this.color,
    required this.height,
    required this.width,
    this.initialHeight,
  }) : super(key: key);

  final int duration;
  final Color color;
  final double height;
  final double width;
  final double? initialHeight;

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController animController;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    animation = Tween<double>(
      begin: 20,
      end: widget.height,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.initialHeight ?? animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
