import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/ui/screens/booking/bloc/services_categories_bloc/services_categories_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/services_categories_enum.dart';
import 'package:o7therapy/ui/screens/booking/widgets/all_therapists_string_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/filter_chips.dart';
import 'package:o7therapy/ui/screens/booking/widgets/group_therapy_page/group_therapy_page.dart';
import 'package:o7therapy/ui/screens/booking/widgets/help_floating_action_button.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/one_on_one_sessions_page.dart';
import 'package:o7therapy/ui/screens/booking/widgets/search_button.dart';
import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_booked_before_widgets/therapists_booked_before_section.dart';

class BookingScreen extends StatelessWidget {
  static const routeName = '/booking-screen';

  const BookingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          floatingActionButton: HelpFloatingActionButton(),
          body: RefreshIndicator(
            onRefresh: () async {
              TherapistsBloc.bloc(context)
                  .add(const GetInitQueryTherapistEvent());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _getBookingScreenContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBookingScreenContent() {
    return CustomScrollView(
      shrinkWrap: true,
      primary: true,
      slivers: [
        SearchButton(),
        // SearchSectionRow(),
        // ServicesCategoriesRow(),
        _getFilterChips(),
        _getTherapistsBookedBeforeSection(),
        _getAllTherapistsStringWidget(),
        _getList(),
      ],
    );
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

  Widget _getAllTherapistsStringWidget() {
    return BlocBuilder<ServicesCategoriesBloc, ServicesCategoriesState>(
        builder: (context, state) {
      if (state.servicesCategory == ServicesCategories.oneOnOneSessions) {
        return AllTherapistsStringRow();
      } else {
        return const ShrinkSliverWidget();
      }
    });
  }

  Widget _getTherapistsBookedBeforeSection() {
    return BlocBuilder<ServicesCategoriesBloc, ServicesCategoriesState>(
        builder: (context, state) {
      if (state.servicesCategory == ServicesCategories.oneOnOneSessions) {
        return TherapistsBookedBeforeSection(ValueNotifier<bool>(false));
      } else {
        return const ShrinkSliverWidget();
      }
    });
  }
}
