import 'package:flutter/material.dart';

class ShrinkSliverWidget extends StatelessWidget {
  const ShrinkSliverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
