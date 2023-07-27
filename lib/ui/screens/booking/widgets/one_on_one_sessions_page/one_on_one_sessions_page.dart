import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking/widgets/exception_booking_screen_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/no_data_found_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/therapist_card.dart';
import 'package:o7therapy/ui/widgets/slivers/sliver_circular_progress_indicator.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class OneOnOneSessionPage extends StatefulWidget {
  const OneOnOneSessionPage({super.key});

  @override
  State<OneOnOneSessionPage> createState() => _OneOnOneSessionPageState();
}

class _OneOnOneSessionPageState extends State<OneOnOneSessionPage> {
  late final TherapistsBloc _therapistsBloc;
  final PagingController<int, TherapistData> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _therapistsBloc = context.read<TherapistsBloc>();
    _therapistsBloc.add(const GetInitQueryTherapistEvent());

    _pagingController.addPageRequestListener(
      (pageKey) => _therapistsBloc.add(const GetMoreTherapistsEvent()),
    );

    _therapistsBloc.stream.listen(_therapistsBlocListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistsBloc, TherapistsState>(
      listener: (context, state) {
        if (state is ExceptionTherapistsState) {
          if (state.exception == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.exception);
        }
      },
      buildWhen: (previous, current) {
        if (current is LoadedTherapistsState && !current.isListUpdated) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingTherapistsState) {
          return const SliverCircularProgressIndicator();
        } else if (state is LoadedTherapistsState) {
          return PagedSliverList<int, TherapistData>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<TherapistData>(
              noItemsFoundIndicatorBuilder: (context) => NoDataFoundWidget(),
              itemBuilder: (context, item, index) => TherapistCard(
                therapistModel: item,
                key: ValueKey(item.id),
              ),
            ),
          );
        } else if (state is ExceptionTherapistsState) {
          return SliverFillRemaining(
              hasScrollBody: true,
              child:
                  Center(child: ExceptionBookingScreenWidget(state.exception)));
        }
        return const SliverCircularProgressIndicator();
      },
    );
  }

  _therapistsBlocListener(TherapistsState state) {
    if (state is LoadedTherapistsState) {
      if (state.isListUpdated) {
        _pagingController.refresh();
      }
      if (!state.hasMore) {
        _pagingController.appendLastPage(state.therapists);
      } else {
        final int nextPageKey = 1 + state.therapists.length;
        _pagingController.appendPage(state.therapists, nextPageKey);
      }
    }
  }
}
