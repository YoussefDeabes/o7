import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/services_categories_bloc/services_categories_bloc.dart';
import 'package:o7therapy/ui/screens/booking/services_categories_enum.dart';
import 'package:o7therapy/ui/screens/booking/widgets/group_therapy_page/group_therapy_page.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/one_on_one_sessions_page.dart';
import 'package:o7therapy/ui/screens/booking/widgets/search_section_row.dart';
import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import '../../../../_base/widgets/base_screen_widget.dart';
import '../../../../_base/widgets/base_stateful_widget.dart';
import '../../../../util/lang/app_localization_keys.dart';
import 'widgets/filter_widgets/filter_chips.dart';

class SearchResultsScreen extends BaseScreenWidget {
  static const routeName = '/search-results-screen';

  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends BaseScreenState<SearchResultsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(
              LangKeys.searchResults,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: CustomScrollView(
              shrinkWrap: true,
              primary: true,
              slivers: [
                SearchSectionRow(),
                _getFilterChips(),
                _getList(),

              ],
            ),
          ),
        ));
  }

  Widget _getFilterChips() {
    return BlocBuilder<ServicesCategoriesBloc, ServicesCategoriesState>(
        builder: (context, state) {
          if (state.servicesCategory == ServicesCategories.oneOnOneSessions) {
            return FilterChips();
          } else {
            return const ShrinkSliverWidget();
          }
        });
  }

  Widget _getList() {
    return BlocBuilder<ServicesCategoriesBloc, ServicesCategoriesState>(
      builder: (context, state) {
        ServicesCategories servicesCategory = state.servicesCategory;
        if (servicesCategory == ServicesCategories.oneOnOneSessions) {
          return const OneOnOneSessionPage();
        } else if (servicesCategory == ServicesCategories.groupTherapy) {
          return const GroupTherapyPage();
        } else if (servicesCategory == ServicesCategories.workshops) {
          // return _getWorkshopsPage(state.workShops);
        }
        return const ShrinkSliverWidget();
      },
    );
  }
}
