import 'package:flutter/material.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';

class ExceptionSliverWidget extends StatelessWidget {
  final String exception;
  const ExceptionSliverWidget({super.key, required this.exception});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: CustomErrorWidget(exception));
  }
}
