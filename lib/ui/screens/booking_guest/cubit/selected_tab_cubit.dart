import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/booking_guest_screen.dart';

class SelectedTabCubit extends Cubit<SelectedTab> {
  SelectedTabCubit() : super(SelectedTab.oneOnOne);

  static SelectedTabCubit bloc(BuildContext context) =>
      context.read<SelectedTabCubit>();

  void changeTab(SelectedTab newSelectedTab) {
    emit(newSelectedTab);
  }
}
