import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking/widgets/exception_booking_screen_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/group_therapy_and_workshops_card.dart';
import 'package:o7therapy/ui/screens/booking/widgets/no_data_found_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/therapist_card.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class GroupTherapyPage extends StatefulWidget {
  const GroupTherapyPage({super.key});

  @override
  State<GroupTherapyPage> createState() => _GroupTherapyPageState();
}

class _GroupTherapyPageState extends State<GroupTherapyPage> {
  List<GroupTherapyModel> list = groupsTherapy;
  // late final GroupTherapyBloc _groupTherapyBloc;
  final PagingController<int, TherapistData> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    // _groupTherapyBloc = context.read<GroupTherapyBloc>();
    // _groupTherapyBloc.add(const GetInitQueryTherapistEvent());

    // _pagingController.addPageRequestListener(
    //   (pageKey) => _groupTherapyBloc.add(const GetMoreTherapistsEvent()),
    // );

    // _groupTherapyBloc.stream.listen(_groupTherapyBlocListener);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
      list.isEmpty
          ? [NoDataFoundWidget()]
          : list
              .map((item) => GroupTherapyAndWorkshopsCard(
                  title: item.title,
                  byWhom: item.byWhom,
                  imageUrl: item.imageLink,
                  startDate: item.startDate,
                  endDate: item.endDate,
                  startTime: item.startTime,
                  endTime: item.endTime,
                  numberOfSpotsAvailable: item.availableSpots))
              .toList(),
    ));
  }

  // return RefreshIndicator(
  //   onRefresh: () async {
  //     GroupTherapyBloc.bloc(context).add(const GetInitQueryTherapistEvent());
  //   },
  //   child: BlocConsumer<GroupTherapyBloc, GroupTherapyState>(
  //     listener: (context, state) {
  //       if (state is ExceptionTherapistsState) {
  //         if (state.exception == "Session expired") {
  //           clearData();
  //           Navigator.of(context).pushNamedAndRemoveUntil(
  //               LoginScreen.routeName, (Route<dynamic> route) => false);
  //         }
  //         showToast(state.exception);
  //       }
  //     },
  //     builder: (context, state) {
  //       if (state is LoadingTherapistsState) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (state is LoadedTherapistsState) {
  //         return PagedListView<int, TherapistData>(
  //           pagingController: _pagingController,
  //           addAutomaticKeepAlives: false,
  //           addRepaintBoundaries: false,
  //           addSemanticIndexes: false,
  //           builderDelegate: PagedChildBuilderDelegate<TherapistData>(
  //             noItemsFoundIndicatorBuilder: (context) => NoDataFoundWidget(),
  //             itemBuilder: (context, item, index) => TherapistCard(
  //               therapistModel: item,
  //             ),
  //           ),
  //         );
  //       } else if (state is ExceptionTherapistsState) {
  //         return ExceptionBookingScreenWidget(state.exception);
  //       }
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   ),
  // );
  // }

  _groupTherapyBlocListener(TherapistsState state) {
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
