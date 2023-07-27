import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/services_categories_bloc/services_categories_bloc.dart';
import 'package:o7therapy/ui/screens/booking/services_categories_enum.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sliver_app_bar_delegate.dart';

class ServicesCategoriesRow extends BaseStatelessWidget {
  ServicesCategoriesRow({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
        maxHeight: 0.055 * height,
        minHeight: 0.055 * height,
        child: Material(
          color: ConstColors.scaffoldBackground,
          child: Container(
            alignment: AlignmentDirectional.center,
            width: width,
            height: height,
            color: ConstColors.scaffoldBackground,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ServicesCategories.values
                  .map<Widget>((servicesCategory) =>
                      ServicesCategoryChip(servicesCategory))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// single chip for Service Category
class ServicesCategoryChip extends BaseStatelessWidget {
  ServicesCategoryChip(
    this.servicesCategory, {
    super.key,
  });
  final ServicesCategories servicesCategory;
  @override
  Widget baseBuild(BuildContext context) {
    return BlocBuilder<ServicesCategoriesBloc, ServicesCategoriesState>(
        builder: (context, state) {
      Color textColor = ConstColors.text;
      Color borderColor = ConstColors.text;
      if (state.servicesCategory == servicesCategory) {
        textColor = Colors.white;
        borderColor = ConstColors.app;
      } else {
        textColor = ConstColors.text;
        borderColor = ConstColors.disabled;
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          shape: StadiumBorder(side: BorderSide(color: borderColor)),
          backgroundColor: Colors.white,
          disabledColor: Colors.white,
          selectedColor: ConstColors.app,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          label: Text(
            translate(servicesCategory.translatedKey),
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          selected: state.servicesCategory == servicesCategory,
          onSelected: (value) {
            if (value) {
              ServicesCategoriesBloc.bloc(context)
                  .add(UpdateServicesCategoriesEvent(servicesCategory));
            }
          },
        ),
      );
    });
  }
}
